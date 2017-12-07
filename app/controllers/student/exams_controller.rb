class Student::ExamsController < ApplicationController
  before_action :set_exam, only: [:show]

  def index
    @exams = selected_user.current_section(current_term).exams.active
  end

  def show
    @exam_timetables = @exam.exam_timetables.by_klass(selected_user.current_section(current_term).klass_id).by_paper_date

    respond_to do |format|
      format.js
      format.html
    end
  end

  def autocomplete
    render json: autocomplete_query(Exam, ["name"], {term_id: current_term.id, status: 'active'}).map{|exam| {search: exam.name}}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.active.find(params[:id])
    end
end
