module Administrator::ExamsHelper
  def exam_status(exam)
    exam.initialized? ? 'Publish' : 'DeActivate'
  end

  def exam_status_class(exam)
    exam.initialized? ? 'btn-primary' : 'btn-warning'
  end
end
