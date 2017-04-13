class Section < ApplicationRecord
  belongs_to :institution
  belongs_to :term
  belongs_to :klass
  belongs_to :incharge, :class_name => "Teacher", :foreign_key => "incharge_id"
  has_many :section_subject_teachers, inverse_of: :section
  has_many :subjects, through: :section_subject_teachers
  has_many :teachers, through: :section_subject_teachers
  accepts_nested_attributes_for :section_subject_teachers, allow_destroy: true
  
  validates :name, presence: {message: "Section name is required"}
  validates :nickname, presence: {message: "Nickname is required"}
  validates :incharge_id, presence: {message: "Selection of class incharge is required"}
  validates :klass_id, presence: {message: "Selection of class is required"}

  def incharge_name
    incharge.name
  end
  
  def display_subjects_count
    subjects.count
  end
end
