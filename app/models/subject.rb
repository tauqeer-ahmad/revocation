class Subject < ApplicationRecord
  include SearchWrapper
  include GlobalParanoiable
  COLORS =  %w(#FF5CB8 #00A1D7 #DEF050 #FFD234 #EB016E #D94430 #27576E #B7CDD1 #E96EA4 #DED36F #AF2F12 #8E3086 #B8AF6D #17E58F #46D0D0 #D66636 #0C9CD6 #E55666 #CA6AE6 #8F3A54 #E34F5D)

  has_paper_trail
  searchkick index_name: tenant_index_name, match: :word_start, searchable: [:name]

  belongs_to :institution
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers
  has_many :teachers, through: :section_subject_teachers
  has_many :assignments
  has_many :exam_timetables
  has_many :marksheets
  has_many :exam_marks
  has_many :question_papers
  has_many :subject_schedules

  validates :name, presence: {message: "Name field is mandatory"}
  validates :color, presence: {message: "Color selection is mandatory"}

  def search_data
    {
      name: name,
      description: description,
      deleted_at: deleted_at,
      deleted_in_term_id: deleted_in_term_id,
    }
  end

  def search_name
    name
  end
end
