class Student < User
  belongs_to :enrollment_term, class_name: 'Term', foreign_key: 'enrollment_term_id'
  belongs_to :guardian

  has_many :section_students
  has_many :sections, through: :section_students
  has_many :terms, through: :section_students
  has_many :klasses, through: :section_students

  validates :roll_number, presence: { message: 'Roll number is required' }
  validates :roll_number, uniqueness: true

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  after_create :send_password

  def set_password
    @password = SecureRandom.hex(10)
    self.password = @password
  end

  def send_password
    StudentMailer.send_password(self, Institution.current, @password).deliver!
  end
end
