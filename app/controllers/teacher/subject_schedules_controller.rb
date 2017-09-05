class Teacher::SubjectSchedulesController < ApplicationController
  before_action :set_subject_schedule, only: [:edit, :update, :destroy]
  before_action :set_edit_objects, only: [:edit]

  def index
    @schedules = current_user.subject_schedules.of_term(current_term.id).includes(:teacher, :subject, :klass, :section, :term)
    @klasses = current_user.my_klasses
    @sections, @subjects = [], []
  end

  def new
    @schedule = SubjectSchedule.new
    @klasses = current_user.my_klasses
    @sections, @subjects = [], []
  end

  def edit
  end

  def create
    @schedule = SubjectSchedule.new(subject_schedules_params)

    if @schedule.save
      redirect_to subject_schedules_path, notice: 'Schedule was successfully Added.'
    else
      redirect_to subject_schedules_path, error: @schedule.errors.full_messages.to_sentence
    end
  end

  def update
    if @schedule.update(subject_schedules_params)
      redirect_to subject_schedules_path, notice: 'Schedule was successfully updated.'
    else
      set_edit_objects
      render :edit
    end
  end

  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to subject_schedules_path, notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_subject_schedule
      @schedule = current_user.subject_schedules.find(params[:id])
    end

    def subject_schedules_params
      params.require(:subject_schedule).permit(:klass_id, :section_id, :subject_id, :content).tap do |whitelisted|
        whitelisted[:teacher_id] = current_user.id
        whitelisted[:term_id] = current_term.id
      end
    end

    def set_edit_objects
      @klasses = current_user.my_klasses
      @sections = SectionSubjectTeacher.includes(:section).term_teacher_klass(current_term.id, current_user.id, @schedule.klass.id).collect(&:section_option).uniq
      @subjects = SectionSubjectTeacher.includes(:subject).term_teacher_section(current_term.id, current_user.id, @schedule.section.id).collect &:subject_option
    end
end
