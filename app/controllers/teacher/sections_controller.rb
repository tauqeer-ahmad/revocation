class Teacher::SectionsController < ApplicationController
  before_action :check_current_term, only: :index
  before_action :set_section, only: [:show, :update_subjects, :tabulation_sheet]

  def index
    teacher_sections = current_user.sections.includes(:klass).of_current_term(current_term.id)
    incharged_sections = current_user.incharged_sections.includes(:klass).of_current_term(current_term.id)
    @sections = teacher_sections | incharged_sections
    if @sections.present?
      @klasses = @sections.collect(&:klass).uniq
      @sections = @sections.group_by(&:klass_id)
      if params[:klass_id].present?
        @klass = Klass.find(params[:klass_id])
      else
        @klass = @klasses.first
      end
      @sections = teacher_sections.includes(:incharge).where(klass_id: @klass.id) | incharged_sections.includes(:incharge).where(klass_id: @klass.id)
      @section_subjects = current_user.section_subject_teachers.includes(:subject).of_term(current_term.id).group_by(&:section_id)
      @assignment = current_term.assignments.build
      @diary_note = current_term.diary_notes.build
    end
  end

  def fetch
    @klass = Klass.find(params[:klass_id])
    @section_subject_teachers = current_user.section_subject_teachers.of_term(current_term.id).includes(:subject).where(klass_id: params[:klass_id])
    @sections = current_user.sections.includes(:incharge).where(klass_id: @klass.id) | current_user.incharged_sections.includes(:incharge).where(klass_id: @klass.id)
    @section_subjects = @section_subject_teachers.group_by(&:section_id)
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
