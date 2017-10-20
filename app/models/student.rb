class Student < User
  include SearchWrapper
  include Authentication

  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:first_name, :last_name, name: :exact]

  belongs_to :enrollment_term, class_name: 'Term', foreign_key: 'enrollment_term_id'
  belongs_to :guardian

  has_many :section_students
  has_many :sections, through: :section_students
  has_many :terms, through: :section_students
  has_many :klasses, through: :section_students
  has_many :exam_marks
  has_many :attendances, as: :attendee

  validates :roll_number, presence: { message: 'Roll number is mandatory' }
  validates :roll_number, uniqueness: {message: 'Roll number must uniqe'}
  validates :registration_number, presence: { message: 'Registration number is mandatory' }
  validates :registration_number, uniqueness: {message: 'Registration number must be unique'}

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  after_create :send_password

  scope :promotable, -> { where("section_students.promoted = ?", false) }
  scope :promoted, -> { where("section_students.promoted = ?", true) }

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      section_id: sections.pluck(:id),
      roll_number: roll_number,
      gender: gender,
      guardian_id: guardian_id,
      registration_number: registration_number,
      deleted_at: deleted_at,
      deleted_in_term_id: deleted_in_term_id,
      name: full_name,
    }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def set_password
    @password = SecureRandom.hex(10)
    self.password = @password
  end

  def send_password
    begin
      StudentMailer.send_password(self, Institution.current, @password).deliver!
    rescue
      logger.info "Password Email not sent for Student #{self.name}"
    end
  end

  def current_section(term_id)
    sections.of_current_term(term_id).first
  end

  def self.generate_registration_number(current_institution, current_term)
    loop do
      random_number = [current_institution.city.first(3), current_term.start_date.year, SecureRandom.hex(5)].join('-').upcase
      break random_number unless self.exists?(registration_number: random_number)
    end
  end
end
