class ExamMarkSerializer < ActiveModel::Serializer
  attributes :id, :obtained, :total, :passing_marks, :comment, :subject_name, :section_name, :klass_name, :student_id
end
