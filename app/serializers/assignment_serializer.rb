class AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :assigned_at, :submission_deadline, :heading, :teacher, :klass, :section, :subject, :task

  def teacher
    object.teacher.name
  end

  def section
    object.section.name
  end

  def subject
    object.subject.name
  end

  def klass
    object.section.klass.name
  end
end
