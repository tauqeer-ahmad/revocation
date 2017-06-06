class Teacher::SectionsController < ApplicationController
  before_action :check_current_term, only: :index
  before_action :set_klass, only: :update_sections
  before_action :set_section, only: :update_subjects

  def index
    @section_subject_teachers = current_user.section_subject_teachers.of_term(current_term.id).includes(:subject, section: :klass)
    @assignment = current_term.assignments.build
  end

  def update_sections
    @sections  = @klass.sections.of_current_term(current_term.id).of_current_user(current_user.sections.pluck(:id))
    render json: @sections.map { |section| section.as_json(:only => [:id, :name]) }
  end

  def update_subjects
    @subjects  = @section.subjects.of_current_user(current_user.subjects.pluck(:id))
    render json: @subjects.map { |subject| subject.as_json(:only => [:id, :name]) }
  end

  private
    def check_current_term
      return redirect_to(root_path) unless current_term.present?
    end

    def set_klass
      @klass = Klass.find(params[:klass_id])
    end

    def set_section
      @section = Section.find(params[:id])
    end
end
