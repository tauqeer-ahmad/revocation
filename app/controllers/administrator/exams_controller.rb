class Administrator::ExamsController < ApplicationController
  before_action :set_exam, only: [:show, :edit, :update, :destroy, :status_update]

  def index
    @exams = Exam.lookup params[:search], {term_id: current_term.id}
    @new_exam = current_term.exams.new
  end

  def show
  end

  def new
    @exam = current_term.exams.new
  end

  def edit
  end

  def create
    @exam = current_term.exams.new(exam_params)

    respond_to do |format|
      if @exam.save
        format.html { redirect_to administrator_exams_url, notice: 'Exam was successfully created.' }
        format.json { render :show, status: :created, location: @exam }
      else
        format.html { render :new }
        format.json { render json: @exam.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @exam.update(exam_params)
        format.html { redirect_to administrator_exams_url, notice: 'Exam was successfully updated.' }
        format.json { render :show, status: :ok, location: @exam }
      else
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
    render json: Exam.search(params[:search], fields: ["name"], where: {term_id: current_term.id}, load: false, misspellings: {below: 5}, limit: 10).map{|exam| {search: exam.name}}
  end

  def status_update
    @exam.toggle_status
    redirect_to administrator_exams_url, notice: "Status changed to #{@exam.status.titleize}."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_params
      params.require(:exam).permit(:name, :start_date, :comment)
    end
end
