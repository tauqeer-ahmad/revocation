class User < ApplicationRecord
  GENDERS = %w(Male Female)
  self.inheritance_column = :type_of
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  acts_as_paranoid

  has_many :notes
  has_many :testimonials

  has_attached_file :avatar,
                    styles: {
                      medium: "300x300!",
                      thumb: "100x100>"
                    },
                    default_url: "/assets/users/:style/missing.jpeg"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  validates :first_name, presence: { message: "First name field is required" }
  validates :last_name, presence: { message: "Last name field is required" }
  validates :email, presence: { message: "First name field is required" }

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
end
