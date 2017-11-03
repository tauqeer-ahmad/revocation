class Section < ApplicationRecord
  acts_as_paranoid

  belongs_to :institution
  belongs_to :term
  belongs_to :klass
  belongs_to :incharge, :class_name => "Teacher", :foreign_key => "incharge_id"

  has_many :section_subject_teachers, inverse_of: :section
  has_many :subjects, through: :section_subject_teachers
  has_many :teachers, through: :section_subject_teachers
  has_many :section_students
  has_many :students, through: :section_students
  has_many :timetables, dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :marksheets, dependent: :destroy
  has_many :exam_marks, dependent: :destroy
  has_many :exam_timetables, dependent: :destroy
  has_many :attendance_sheets, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :question_papers, dependent: :destroy
  has_many :subject_schedules, dependent: :destroy

  accepts_nested_attributes_for :section_subject_teachers, allow_destroy: true
  accepts_nested_attributes_for :timetables, allow_destroy: true

  validates :name, presence: {message: "Section name is mandatory"}
  validates :nickname, presence: {message: "Nickname is mandatory"}
  validates :incharge_id, presence: {message: "Selection of class incharge is mandatory"}
  validates :klass_id, presence: {message: "Selection of class is mandatory"}

  scope :of_current_term, -> (term_id) { where(term_id: term_id) }

  def incharge_name
    incharge&.name
  end

  def display_subjects_count
    subjects.count
  end

  def display_teachers_count
    section_subject_teachers.map(&:teacher_id).uniq.count
  end

  def display_students_count
    students.count
  end

  def klass_name
    klass.name
  end

  def title_with_klass
    [klass.name, name].join(' - ')
  end

  def get_teacher_by_subject(subject_id)
    section_subject_teachers.by_subject_id(subject_id).last.teacher_id if subject_id.present?
  end

  def student_hash
    students.pluck(:id, :roll_number, :first_name, :last_name).inject({}) { |memo, obj| memo[obj.first] = [obj[1] ,obj[2], obj[3]]; memo }
  end

  def self.all_sections_list
    includes(:klass).collect {|section| [section.id, "#{section.klass.name} - #{section.name}"]}
  end
end
