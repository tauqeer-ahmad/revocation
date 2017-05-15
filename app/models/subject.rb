class Subject < ApplicationRecord
  include SearchWrapper

  searchkick index_name: tenant_index_name

  belongs_to :institution
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers
  has_many :teachers, through: :section_subject_teachers

  def search_data
    {
      name: name,
      description: description,
    }
  end
end
