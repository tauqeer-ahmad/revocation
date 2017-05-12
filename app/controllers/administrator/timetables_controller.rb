class Administrator::TimetablesController < ApplicationController
  before_action :set_section
  before_action :set_timetable, only: [:show, :edit, :update, :destroy]
  before_action :set_new_timetable_data, only: [:index, :edit, :new, :update]

  def index
    @timetables = @section.timetables.order('day_of_week asc').group_by(&:day_of_week)
    @new_timetable = Timetable.new
    @days_hash = Timetable::DAYS
  end

  def show
  end

  def new
    @timetable = Timetable.new
  end

  def edit
  end

  def create
    @timetable = @section.timetables.new(timetable_params)
    @timetable.klass_id = @section.klass_id
    @timetable.term_id = @section.term_id
    @timetable.teacher_id = @section.section_subject_teachers.where(subject_id: @timetable.subject_id).last.teacher_id if @timetable.subject_id
    respond_to do |format|
      if @timetable.save
        format.html { redirect_to administrator_section_timetables_url(@section), notice: 'Timetable was successfully created.' }
        format.json { render :show, status: :created, location: @timetable }
      else
        format.html { render :new }
        format.json { render json: @timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @timetable.update(timetable_params)
        format.html { redirect_to administrator_section_timetables_url(@section), notice: 'Timetable was successfully updated.' }
        format.json { render :show, status: :ok, location: @timetable }
      else
        format.html { render :edit }
        format.json { render json: @timetable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @timetable.destroy
    respond_to do |format|
      format.html { redirect_to administrator_section_timetables_url(@section), notice: 'Timetable was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_section
      @section = current_term.sections.find(params[:section_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_timetable
      @timetable = Timetable.find(params[:id])
    end

    def set_new_timetable_data
      @subjects = @section.subjects.pluck(:name, :id)
      @days = Timetable::get_days_arr
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timetable_params
      params.require(:timetable).permit(:start_time, :end_time, :day_of_week, :subject_id)
    end
end
