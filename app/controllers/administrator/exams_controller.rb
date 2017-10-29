class Administrator::ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy, :status_update]

  def index
    where_clause = {term_id: current_term.id}
    where_clause[:section_id] = params[:section_id].to_i if params[:section_id].present?
    @exams = []
    if params[:search].present? || params[:section_id].present?
      @exams = Exam.lookup params[:search], {where: where_clause}
    end
    @new_exam = current_term.exams.new
    set_new_exam_data
  end

  def show
    @exam_timetables = @exam.exam_timetables.by_paper_date
  end

  def new
    set_new_exam_data
    return redirect_to administrator_exams_url, alert: 'Class and section must be selected' unless params[:section_id].present? && params[:klass_id].present?
    @exam = current_term.exams.new(klass_id: params[:klass_id], section_id: params[:section_id])
    @section = Section.find(params[:section_id])
    @subjects_hash = {}
    @subjects = @section.subjects.collect{|s| @subjects_hash[s.id] = s.name}
    @exam_timetables = @exam.exam_timetables.where(klass_id: params[:klass_id], section_id: params[:section_id]).to_a

    existing_timetables = @exam_timetables.collect(&:subject_id)
    new_subjects = @subjects_hash.keys - existing_timetables
    new_subjects.each do |new_subject|
      @exam_timetables << @exam.exam_timetables.build(klass_id: params[:klass_id], section_id: params[:section_id], term_id: current_term.id, subject_id: new_subject)
    end
  end

  def edit
    set_new_exam_data
    @section = @exam.section
    @subjects_hash = {}
    @subjects = @section.subjects.collect{|s| @subjects_hash[s.id] = s.name}
    @exam_timetables = @exam.exam_timetables.to_a

    existing_timetables = @exam_timetables.collect(&:subject_id)
    new_subjects = @subjects_hash.keys - existing_timetables
    new_subjects.each do |new_subject|
      @exam_timetables << @exam.exam_timetables.build(klass_id: params[:klass_id], section_id: params[:section_id], term_id: current_term.id, subject_id: new_subject)
    end
  end

  def create
    @exam = current_term.exams.new(exam_params)

    respond_to do |format|
      if @exam.save
        format.html { redirect_to administrator_exams_url(klass_id: @exam.klass_id,section_id: @exam.section_id), notice: 'Exam was successfully created.' }
        format.json { render :show, status: :created, location: @exam }
      else
        set_new_exam_data
        @section = Section.find(@exam.section_id)
        @subjects_hash = {}
        @subjects = @section.subjects.collect{|s| @subjects_hash[s.id] = s.name}
        format.html { render :new }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @exam.update(exam_params)
        format.html { redirect_to administrator_exams_url(klass_id: @exam.klass_id,section_id: @exam.section_id), notice: 'Exam was successfully updated.' }
        format.json { render :show, status: :ok, location: @exam }
      else
        set_new_exam_data
        @section = Section.find(@exam.section_id)
        @subjects_hash = {}
        @subjects = @section.subjects.collect{|s| @subjects_hash[s.id] = s.name}
        format.html { render :edit }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @exam.destroy
    respond_to do |format|
      format.html { redirect_to administrator_exams_url, notice: 'Exam was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autocomplete
    render json: autocomplete_query(Exam, ["name"], {term_id: current_term.id}).map{|exam| {search: exam.name}}
  end

  def status_update
    @exam.toggle_status
    redirect_to administrator_exams_url(klass_id: @exam.klass_id,section_id: @exam.section_id), notice: "Status changed to #{@exam.status.titleize}."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    def set_new_exam_data
      @klasses = Klass.all
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:klass_id, :section_id, :percentage, :name, :start_date, :comment, exam_timetables_attributes: [:id, :start_time, :end_time, :paper_date, :term_id, :klass_id, :section_id, :subject_id, :_destroy])
    end
end
