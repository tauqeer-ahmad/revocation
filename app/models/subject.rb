class Subject < ApplicationRecord
  include SearchWrapper

  searchkick index_name: tenant_index_name

  belongs_to :institution
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers
  has_many :teachers, through: :section_subject_teachers
  has_many :assignments
  has_many :exam_timetables
  has_many :marksheets
  has_many :exam_marks

  def search_data
    {
      name: name,
      description: description,
    }
  end
end
