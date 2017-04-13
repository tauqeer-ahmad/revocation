class Teacher < User
  belongs_to :institution
  has_many :incharged_sections, :class_name => "Section", :foreign_key => "incharge_id"
  has_many :section_subject_teachers
  has_many :sections, through: :section_subject_teachers
end
