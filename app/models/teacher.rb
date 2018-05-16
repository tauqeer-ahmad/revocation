class Teacher < User
  include SearchWrapper
  include Authentication

  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:first_name, :last_name, name: :exact]

  belongs_to :institution
  has_many :incharged_sections, :class_name => "Section", :foreign_key => "incharge_id"
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers
  has_many :subjects, through: :section_subject_teachers
  has_many :attendances, as: :attendee
  has_many :teacher_attendances, dependent: :destroy
  has_many :assignments
  has_many :question_papers
  has_many :subject_schedules
  has_many :students, through: :sections
  validates :phone, presence: { message: "Phone field is mandatory" }

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  after_create :send_password

  scope :ordered, -> {order(id: :asc)}

  def search_data
    {
      first_name: first_name,
      last_name: last_name,
      email: email,
      qualification: qualification,
      profession: profession,
      deleted_at: deleted_at,
      deleted_in_term_id: deleted_in_term_id,
      name: full_name,
    }
  end

  def search_name
    full_name
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
      TeacherMailer.send_password(self, Institution.current, @password).deliver!
    rescue
      logger.info "Password Email not sent for Teacher #{self.name}"
    end
  end

  def incharged_sections_list(current_term_id)
    incharged_sections.where(term_id: current_term_id).includes(:klass).collect {|section| [section.id, "#{section.klass.name} - #{section.name}"]}
  end

  def optgroup_incharged_sections_list(current_term_id)
    response = {}
    incharged_sections.where(term_id: current_term_id).includes(:klass).collect {|section| response[section.klass.name] = []if response[section.klass.name].blank?; response[section.klass.name] << [section.name, section.id]}
    response
  end

  def optgroup_teacher_sections_list(current_term_id)
    response = {}
    sections.includes(:klass).of_current_term(current_term_id).collect {|section| response[section.klass.name] = []if response[section.klass.name].blank?; response[section.klass.name] << [section.name, section.id]}
    response
  end

  def self.data_hash
    all.pluck(:id, :email, :first_name, :last_name, :profession).inject({}) { |memo, obj| memo[obj.first] = [obj[1] ,obj[2], obj[3]]; memo }
  end

  def validate_section_and_subject(selected_section, selected_subject)
    [selected_section.id, selected_subject.id].in? section_subject_teachers.collect {|section_subject_teachers| [section_subject_teachers.section_id, section_subject_teachers.subject_id]}
  end

  def sections?
    sections.exists?
  end

  def incharged_sections?
    incharged_sections.exists?
  end

  def my_klasses
    return self.sections.includes(:klass).collect{|section| [section.klass.name, section.klass.id]}.uniq
  end

  def subject_timetable_events(current_term)
    subject_ids = self.section_subject_teachers.pluck(:subject_id)
    timetables = Timetable.includes(:subject).where(subject_id: subject_ids, term_id: current_term.id).by_day_of_week
    Timetable.events(timetables)
  end

end
