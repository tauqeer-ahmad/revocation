class ExamMarkSerializer < ActiveModel::Serializer
  attributes :obtained, :total, :passing_marks, :comment, :subject_name, :section_name, :klass_name
end
