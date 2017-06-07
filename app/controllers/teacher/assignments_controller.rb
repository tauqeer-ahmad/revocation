class Teacher::AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:edit, :update, :destroy]
  before_action :set_class_section_subject, only: [:index, :edit]

  def index
    @assignments = current_user.assignments.of_section(@section.id).of_subject(@subject.id).ordered
    @assignment = Assignment.new(section_id: @section.id, subject_id: @subject.id)
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params)

    if @assignment.save
      redirect_to sections_path, notice: 'Assignment was successfully updated.'
    else
      redirect_to sections_path, error: @assignment.errors.full_messages.to_sentence
    end
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to sections_path, notice: 'Assignment was successfully updated.'
    else
      set_class_section_subject
      render :edit
    end
  end

  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to "/assignments_path/#{@assignment.section_id}/#{@assignment.subject_id}", notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_assignment
      @assignment = current_user.assignments.find(params[:id])
    end

    def assignment_params
      params.require(:assignment).permit(:heading, :assigned_at, :submission_deadline, :task, :subject_id, :section_id).tap do |whitelisted|
        whitelisted[:teacher_id] = current_user.id
        whitelisted[:term_id] = current_term.id
      end
    end

    def set_class_section_subject
      @section = Section.find(params[:section_id] || @assignment.section_id)
      @klass = @section.klass
      @subject = Subject.find(params[:subject_id] || @assignment.subject_id)

      redirect_to sections_path, notice: 'Invalid Access.' unless current_user.validate_section_and_subject(@section, @subject)
    end
end
