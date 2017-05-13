class Teacher < User
  belongs_to :institution
  has_many :incharged_sections, :class_name => "Section", :foreign_key => "incharge_id"
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  after_create :send_password

  def set_password
    @password = SecureRandom.hex(10)
    self.password = @password
  end

  def send_password
    TeacherMailer.send_password(self, Institution.current, @password).deliver!
  end
end
