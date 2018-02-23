class Teacher::StudentsController < ApplicationController

  before_action :set_section, only: [:results, :autocomplete]
  before_action :set_student, only: [:results]

  def results
    @results = @student.results_json(current_term)
    render layout: false
  end

  def autocomplete
    render json: autocomplete_query(Student, ["first_name", "last_name"], {section_id: @section.id}).map{|student| {search: [student.first_name, ' ', student.last_name].join}}
  end

  private

  def set_section
    @section = Section.find(params[:section_id])
  end

  def set_student
     @student = Student.find(params[:id])
  end

end
