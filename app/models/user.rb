class User < ApplicationRecord
  include GlobalParanoiable

  attr_accessor :login

  GENDERS = %w(Male Female)
  self.inheritance_column = :type_of

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, authentication_keys: [:login]

  has_many :notes, dependent: :destroy
  has_many :testimonials, dependent: :destroy
  # has_many :messages, through: :conversations, source: :conversation
  # has_many :messages, class_name: 'Message', foreign_key: :recipient_id
  # has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id

  has_attached_file :avatar,
                    styles: {
                      medium: "300x300!",
                      thumb: "100x100>"
                    },
                    default_url: "/assets/users/:style/missing.jpeg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  validates :first_name, presence: { message: "First name field is mandatory" }
  validates :last_name, presence: { message: "Last name field is mandatory" }
  validates :username, presence: true, uniqueness: true
  validate :validate_username

  before_validation :set_default_email, if: Proc.new { self.email.blank? }
  after_initialize :create_login, if: :new_record?

  def create_login
    if self.username.blank?
      email = self.email.split(/@/)
      login_taken = User.where(:username => email[0]).first

      unless login_taken
        self.username = email[0]
      else
        self.username = self.email
      end
    end
  end

  def self.type_ofs
    %w(Administrator Teacher Student Guardian Supervisor)
  end

  self.type_ofs.each do |classification|
    define_method "#{classification.downcase}?" do
      self.type_of == classification
    end
  end

  def name
    [first_name, last_name].join(' ')
  end

  def category
    self.type_of.downcase
  end

  def self.get_resource_and_key_name(fullpath)
    path_name = fullpath.split('/')[2]
    path_name = path_name.to_s.singularize
    resource_name = path_name.capitalize.constantize

    resource_name
  end

  def global_search_models
    models = if self.administrator?
               ADMIN_GLOBAL_SEARCH
             elsif self.teacher?
               TEACHER_GLOBAL_SEARCH
             end

    models.collect { |model| model.constantize.searchkick_index.name }
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  private
    def set_default_email
      self.email = "default+#{Time.now.to_i}@revocation.pk"
    end

    def validate_username
      if User.where(email: username).exists?
        errors.add(:username, :invalid)
      end
    end
end
