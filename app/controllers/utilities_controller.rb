class UtilitiesController < ApplicationController
   before_action :set_section, only: [:update_subjects, :update_exams]

   def update_sections
    @klass = Klass.find(params[:klass_id])
    if params[:specific].blank?
      term_id = params[:initialized].present? ? Term.initialized.first.id : current_term.id
      @sections  = @klass.sections.of_current_term(term_id)
    else
      @sections  = SectionSubjectTeacher.includes(:section).term_teacher_klass(current_term.id, current_user.id, @klass.id).collect(&:section).uniq
    end
    render json: @sections.map { |section| section.as_json(:only => [:id, :name]) }
  end

  def update_subjects
    if params[:specific].blank?
      @subjects  = @section.subjects
    else
      @subjects  = SectionSubjectTeacher.includes(:subject).term_teacher_section(current_term.id, current_user.id, @section.id).collect(&:subject)
    end

    render json: @subjects.map { |subject| subject.as_json(:only => [:id, :name]) }
  end

  def update_exams
    @exams = @section.exams.active
    render json: @exams.map { |exam,| exam.as_json(:only => [:id, :name]) }
  end

  private

  def set_section
    @section = Section.find(params[:section_id])
  end
end
