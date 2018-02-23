class Teacher::SectionsController < ApplicationController
  before_action :check_current_term, only: :index
  before_action :set_klass, only: :update_sections
  before_action :set_section, only: [:show, :update_subjects]
  before_action :validate_term, only: [:update_sections, :update_subjects]

  def index
    @section_subject_teachers = current_user.section_subject_teachers.of_term(current_term.id).includes(:subject, section: :klass)
    @assignment = current_term.assignments.build
  end

  def show
    @students = params[:search].present? ? Student.lookup(params[:search], {where: {section_id: @section.id}}) : @section.students
  end

  def update_sections
    @sections  = SectionSubjectTeacher.includes(:section).term_teacher_klass(current_term.id, current_user.id, @klass.id).collect(&:section).uniq
    render json: @sections.map { |section| section.as_json(:only => [:id, :name]) }
  end

  def update_subjects
    @subjects  = SectionSubjectTeacher.includes(:subject).term_teacher_section(current_term.id, current_user.id, @section.id).collect(&:subject)
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
