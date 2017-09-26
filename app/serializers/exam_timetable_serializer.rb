class ExamTimetableSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :klass_name, :subject_name, :exam_color, :paper_date

  def start_time
    object.get_start_time
  end

  def end_time
    object.get_end_time
  end

  def exam_color
    object.get_exam_color
  end
end
