class Student::ResultsController < ApplicationController
  def index
    @student = current_user
    @results = @student.results_json(current_term)
    @section = @student.current_section(current_term.id)
    @exam_marks = @student.exam_marks.where(section_id: @section.id, term_id: current_term.id)
    @exam_grouped = @exam_marks.group_by(&:exam_id)
    @subject_grouped = @exam_marks.group_by(&:subject_id)
    @grade_mappings = {}
    @section.grades.each do |grade|
      @grade_mappings[grade.start_point..grade.end_point] = grade.name
    end
  end
end
