class Teacher < User
  include SearchWrapper

  searchkick index_name: tenant_index_name

  belongs_to :institution
  has_many :incharged_sections, :class_name => "Section", :foreign_key => "incharge_id"
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers
  has_many :attendances, as: :attendee

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  after_create :send_password

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      qualification: qualification,
      profession: profession,
    }
  end

  def set_password
    @password = SecureRandom.hex(10)
    self.password = @password
  end

  def send_password
    TeacherMailer.send_password(self, Institution.current, @password).deliver!
  end

  def incharged_sections_list(current_term_id)
    incharged_sections.where(term_id: current_term_id).includes(:klass).collect {|section| [section.id, "#{section.klass.name} - #{section.name}"]}
  end

  def self.data_hash
    all.pluck(:id, :email, :first_name, :last_name, :profession).inject({}) { |memo, obj| memo[obj.first] = [obj[1] ,obj[2], obj[3]]; memo }
  end
end
