class Administrator::ExamTimetablesController < ApplicationController
  before_action :set_exam
  before_action :set_exam_timetable, only: [:edit, :update, :destroy]
  before_action :set_new_exam_timetable_data, only: [:index, :edit, :new, :bulk, :bulk_form]

  def index
    @exam_timetables = @exam.exam_timetables.by_paper_date
    @new_exam_timetable = ExamTimetable.new(term_id: current_term.id)
    @subjects = @exam.section.subjects

    @subjects_hash = {}
    @exam.section.subjects.collect{|s| @subjects_hash[s.id] = s.name}

    existing_timetables = @exam.exam_timetables.collect(&:subject_id)
    new_subjects = @subjects_hash.keys - existing_timetables
    new_subjects.each do |new_subject|
      @exam.exam_timetables.build(klass_id: @exam.klass_id, section_id: @exam.section_id, term_id: current_term.id, subject_id: new_subject)
    end
  end

  def edit
    @subjects = @exam.section.subjects
  end

  def new
    @exam_timetable = @exam.exam_timetables.new(term_id: current_term.id)
    @subjects = @exam.section.subjects
  end

  def bulk
    @section = @exam.section
    @subjects_hash = {}
    @subjects = @section.subjects.collect{|s| @subjects_hash[s.id] = s.name}
    @exam_timetables = @exam.exam_timetables.to_a

    existing_timetables = @exam_timetables.collect(&:subject_id)
    new_subjects = @subjects_hash.keys - existing_timetables
    new_subjects.each do |new_subject|
      @exam_timetables << @exam.exam_timetables.build(klass_id: @exam.klass_id, section_id: @exam.section_id, term_id: current_term.id, subject_id: new_subject)
    end
  end

  def create
    @exam_timetable = @exam.exam_timetables.new(exam_timetable_params)
    @subjects = @exam.section.subjects
    @exam_timetable.klass_id = @exam.klass_id
    @exam_timetable.section_id = @exam.section_id
    respond_to do |format|
      if @exam_timetable.save
        format.html { redirect_to administrator_exam_exam_timetables_url(@exam), notice: 'Exam timetable was successfully created.' }
        format.json { render :show, status: :created, location: @exam_timetable }
      else
        exam_timetable_params
        set_new_exam_timetable_data
        format.html { render :new }
        format.json { render json: @exam_timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @subjects = @exam.section.subjects
    respond_to do |format|
      if @exam_timetable.update(exam_timetable_params)
        format.html { redirect_to administrator_exam_exam_timetables_url(@exam), notice: 'Exam timetable was successfully updated.' }
        format.json { render :show, status: :ok, location: @exam_timetable }
      else
        exam_timetable_params
        set_new_exam_timetable_data
        format.html { render :edit }
        format.json { render json: @exam_timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subjects = @exam.section.subjects
    @exam_timetable.destroy
    respond_to do |format|
      format.html { redirect_to administrator_exam_exam_timetables_url(@exam), notice: 'Exam timetable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_create
    respond_to do |format|
      if @exam.update(bulk_exam_timetable_params)
        format.html { redirect_to administrator_exam_exam_timetables_url(@exam), notice: 'Exam timetable was successfully created.' }
        format.json { render :show, status: :created, location: @exam }
      else
         @subjects_hash = {}
         @subjects = @exam.section.subjects.collect{|s| @subjects_hash[s.id] = s.name}
        bulk_exam_timetable_params
        set_new_exam_timetable_data
        format.html { redirect_to bulk_administrator_exam_exam_timetables_path(@exam, section_id: params), alert: @exam.errors.full_messages.to_sentence }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam_timetable
      @exam_timetable = @exam.exam_timetables.find(params[:id])
    end

    def set_exam
      @exam = Exam.find(params[:exam_id])
    end

    def set_new_exam_timetable_data
      @klasses = Klass.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_timetable_params
      params.require(:exam_timetable).permit(:start_time, :end_time, :paper_date, :subject_id).tap do |whitelisted|
        whitelisted[:term_id] = current_term.id
      end
    end

    def bulk_exam_timetable_params
      params.require(:exam).permit(exam_timetables_attributes: [:id, :start_time, :end_time, :paper_date, :term_id, :klass_id, :section_id, :subject_id, :_destroy])
    end
end
