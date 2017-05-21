class Student < User
  include SearchWrapper

  searchkick index_name: tenant_index_name

  belongs_to :enrollment_term, class_name: 'Term', foreign_key: 'enrollment_term_id'
  belongs_to :guardian

  has_many :section_students
  has_many :sections, through: :section_students
  has_many :terms, through: :section_students
  has_many :klasses, through: :section_students
  has_many :attendances, as: :attendee

  validates :roll_number, presence: { message: 'Roll number is required' }
  validates :roll_number, uniqueness: true

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  after_create :send_password

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      section_id: sections.pluck(:id),
      roll_number: roll_number,
      gender: gender,
      guardian_id: guardian_id,
    }
  end

  def set_password
    @password = SecureRandom.hex(10)
    self.password = @password
  end

  def send_password
    StudentMailer.send_password(self, Institution.current, @password).deliver!
  end
end
