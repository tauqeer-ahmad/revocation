class SectionSubjectTeacherSerializer < ActiveModel::Serializer
  attributes :class_name, :section, :incharge, :your_subject, :students, :section_id, :incharge_id

  def class_name
    object.klass.name
  end

  def section
    object.section.name
  end

  def incharge
    object.section.incharge_name
  end

  def your_subject
    object.subject.name
  end

  def students
    object.section.display_students_count
  end

  def section_id
    object.section.id
  end

  def incharge_id
    object.section.incharge_id
  end
end
