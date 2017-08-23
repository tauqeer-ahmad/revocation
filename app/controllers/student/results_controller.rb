class Student::ResultsController < ApplicationController
  def index
    @student = current_user
    @exam_marks = @student.exam_marks.includes(:subject, :klass, :section).eager_load(:exam).where(term_id: current_term.id).group_by(&:exam_id)
    @all_exam_marks = ExamMark.where(section_id: @student.sections.ids).to_a
    @klass_marks = @all_exam_marks.group_by(&:klass_id)
    @section_marks = @all_exam_marks.group_by(&:section_id)
    @subject_marks = @all_exam_marks.group_by(&:subject_id)
    @exams = Exam.pluck(:id, :name).to_h
  end
end
