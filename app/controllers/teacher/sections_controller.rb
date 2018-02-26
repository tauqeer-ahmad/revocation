class Teacher::SectionsController < ApplicationController
  before_action :check_current_term, only: :index
  before_action :set_section, only: [:show, :update_subjects, :tabulation_sheet]

  def index
    @section_subject_teachers = current_user.section_subject_teachers.of_term(current_term.id).includes(:subject, section: :klass)
    @assignment = current_term.assignments.build
  end

  def show
    @students = params[:search].present? ? Student.lookup(params[:search], {where: {section_id: @section.id}}) : @section.students
  end

  def tabulation_sheet
    @section_id = params[:id]

    @results = @section.create_tabulation_sheet
  end

  private
    def check_current_term
      return redirect_to(root_path) unless current_term.present?
    end

    def set_section
      @section = Section.find(params[:id])
    end
end
