class Administrator::ExamTimetablesController < ApplicationController
  before_action :set_exam
  before_action :set_exam_timetable, only: [:show, :edit, :update, :destroy]
  before_action :set_new_exam_timetable_data, only: [:index, :new, :edit]

  def index
    @exam_timetables = @exam.exam_timetables.by_paper_date
    @new_exam_timetable = @exam.exam_timetables.new(term_id: current_term.id)
  end

  def show
  end

  def new
    @exam_timetable = @exam.exam_timetables.new(term_id: current_term.id)
  end

  def edit
  end

  def create
    @exam_timetable = @exam.exam_timetables.new(exam_timetable_params)

    respond_to do |format|
      if @exam_timetable.save
        format.html { redirect_to administrator_exam_exam_timetables_url(@exam), notice: 'Exam timetable was successfully created.' }
        format.json { render :show, status: :created, location: @exam_timetable }
      else
        exam_timetable_params
        format.html { render :new }
        format.json { render json: @exam_timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @exam_timetable.update(exam_timetable_params)
        format.html { redirect_to administrator_exam_exam_timetables_url(@exam), notice: 'Exam timetable was successfully updated.' }
        format.json { render :show, status: :ok, location: @exam_timetable }
      else
        exam_timetable_params
        format.html { render :edit }
        format.json { render json: @exam_timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @exam_timetable.destroy
    respond_to do |format|
      format.html { redirect_to administrator_exam_exam_timetables_url(@exam), notice: 'Exam timetable was successfully destroyed.' }
      format.json { head :no_content }
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
      params.require(:exam_timetable).permit(:start_time, :end_time, :paper_date, :klass_id, :subject_id).tap do |whitelisted|
        whitelisted[:term_id] = current_term.id
      end
    end
end
