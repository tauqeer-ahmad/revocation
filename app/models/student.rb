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
  has_many :student_attendances, dependent: :destroy

  validates :roll_number, presence: { message: 'Roll number is mandatory' }
  validates :registration_number, presence: { message: 'Registration number is mandatory' }
  validates :registration_number, uniqueness: {message: 'Registration number must be unique'}
  validate :roll_number_uniqueness, if: Proc.new { self.roll_number_changed? }

  before_validation :set_password, if: Proc.new { !self.encrypted_password? }
  before_validation :set_registration_number, if: Proc.new { !self.registration_number? }

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

  def set_registration_number
    self.registration_number = loop do
      random_number = [Institution.current.city.first(3), Current.term.start_date.year, SecureRandom.hex(5)].join('-').upcase
      break random_number unless self.class.exists?(registration_number: random_number)
    end
  end

  def roll_number_uniqueness
    section_student = self.section_students.first
    return true if section_student.blank?
    existing_roll_numbers = section_student.section.students.pluck(:roll_number)
    errors.add(:roll_number, "Roll number already assigned for this section") if self.roll_number.in?(existing_roll_numbers)
  end

  def results_json(current_term)
    response = {collective: {results: [], total: {}}, exam_results: []}
    section = self.current_section(current_term.id)
    section_exams = section.exams.active
    exam_ids = section_exams.collect(&:id)
    exam_marks = self.exam_marks.where(section_id: section.id, term_id: current_term.id, exam_id: exam_ids)
    exam_grouped = exam_marks.group_by(&:exam_id)
    subject_grouped = exam_marks.group_by(&:subject_id)
    grade_mappings = {}
    section.grades.each do |grade|
      grade_mappings[grade.start_point..grade.end_point] = grade.name
    end

    section.subjects.each do |subject|
      result = {}
      percentage_sum = section_exams.collect(&:percentage).sum
      actual_obtained_marks = exam_marks.where(subject_id: subject.id).sum(:actual_obtained).to_f
      result[:subject] = subject.name
      result[:abs_marks] = exam_marks.where(subject_id: subject.id, exam_id: exam_ids).sum(:actual_obtained).to_f
      result[:total] = section_exams.collect(&:percentage).sum
      result[:percentage] = calculate_percentage(actual_obtained_marks, percentage_sum)
      result[:grade] = assign_grade(calculate_percentage(actual_obtained_marks, percentage_sum), grade_mappings)
      result[:highest] = section.exam_marks.where(subject_id: subject.id, exam_id: exam_ids).group(:student_id).sum(:actual_obtained).values.max
      response[:collective][:results] << result
    end
    total = {}
    total[:abs_marks] = exam_marks.where(exam_id: exam_ids).sum(:actual_obtained).to_f
    total[:total] = section_exams.collect(&:percentage).sum * section.subjects.size
    total[:percentage] = calculate_percentage(total[:abs_marks], total[:total])
    total[:grade] = assign_grade(total[:percentage], grade_mappings)
    total[:highest] = section.exam_marks.where(exam_id: exam_ids).group(:student_id).sum(:actual_obtained).values.max
    response[:collective][:total] = total

    exam_results = []
    section_exams.each_with_index do |exam, index|
      section_exam_marks = exam.exam_marks
      exam_result = {exam_name: exam.name, exam_percentage: exam.percentage, results: [], total: {}}
      section.subjects.each do |subject|
        result = {}
        subject_exam = exam_grouped[exam.id].to_a.select{|e| e.subject_id == subject.id}.first
        result[:subject] = subject.name
        result[:obtained] = subject_exam.try(:obtained)
        result[:total] = subject_exam.try(:total)
        result[:actual_obtained] = subject_exam.try(:actual_obtained)
        result[:percentage] = calculate_percentage(result[:actual_obtained], exam.percentage)
        result[:grade] = subject_exam.try(:grade)
        result[:highest] = section_exam_marks.where(subject_id: subject.id).pluck(:actual_obtained).max
        exam_result[:results] << result
      end
      exam_result[:total][:obtained] = get_obtained_marks(exam_grouped[exam.id])
      exam_result[:total][:total] = get_total_marks(exam_grouped[exam.id])
      exam_result[:total][:actual_obtained] = get_actual_marks(exam_grouped[exam.id])
      exam_result[:total][:percentage] = calculate_percentage(exam_result[:total][:actual_obtained], exam.percentage*section.subjects.size)
      exam_result[:total][:grade] = assign_grade(exam_result[:total][:percentage], grade_mappings)
      exam_result[:total][:highest] = section_exam_marks.group(:student_id).sum(:obtained).values.max

      exam_results << exam_result
    end
    response[:exam_results] = exam_results
    response
  end

  def calculate_percentage(value, total)
    return 0.0 if total.zero?
    '%.1f' % ((value.to_f / total) * 100)
  end

  def calculate_average(values, count)
    return 0.0 if count.zero?
    '%.1f' % (values.to_f/count.to_f)
  end

  def assign_grade(percentage, grade_mappings)
    return "-" if grade_mappings.blank?
    grade = grade_mappings.select {|x| x === percentage.to_f}.values.first
    return grade if grade.present?
    "F"
  end

  def get_obtained_marks(exams)
    return "-" if exams.blank?
    exams.collect(&:obtained).sum
  end

  def get_total_marks(exams)
    return "-" if exams.blank?
    exams.collect(&:total).sum
  end

  def get_actual_marks(exams)
    return "-" if exams.blank?
    exams.collect(&:actual_obtained).sum
  end

end
