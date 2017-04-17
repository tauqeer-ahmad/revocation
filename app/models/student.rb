class Student < User
  validates :roll_number, presence: {message: "Roll number is required"}

  belongs_to :enrollment_term, :class_name => "Term", :foreign_key => "enrollment_term_id"
  has_many :section_students
  has_many :sections, through: :section_students
  has_many :terms, through: :section_students
  has_many :klasses, through: :section_students
  
end
