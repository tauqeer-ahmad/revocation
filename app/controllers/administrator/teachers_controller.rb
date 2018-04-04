class Administrator::TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy, :attendance]

  def index
    @teachers = Teacher.lookup params[:search]
    @new_teacher = Teacher.new
  end

  def show
    @section_subjects = @teacher.section_subject_teachers.includes(:subject, section: :klass)
  end

  def new
    @teacher = Teacher.new
  end

  def edit
  end

  def create
    @teacher = Teacher.new(teacher_params)
    respond_to do |format|
      if @teacher.save
        format.html { redirect_to administrator_teachers_url, notice: 'Teacher was successfully created.' }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html { render :new }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @teacher.update(teacher_params)
        format.html { redirect_to administrator_teachers_url, notice: 'Teacher was successfully updated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @teacher.destroy
    @teacher.reload
    @teacher.save
    respond_to do |format|
      format.html { redirect_to administrator_teachers_url, notice: 'Teacher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_insert
    Teacher.create(bulk_teacher_params)
    redirect_to administrator_teachers_path
  end

  def autocomplete
    render json: autocomplete_query(Teacher, ["first_name", "last_name"]).map{|teacher| {search: [teacher.first_name, ' ', teacher.last_name].join}}
  end

  def attendance
    @formated_results, @key_to_dates, @month_statistics, @month_late_statistics, @attendances, @report_range, @start_date, @end_date = TeacherAttendance.fetch_teacher_report_data(params, current_term, @teacher)
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Attendance Report - #{@teacher.full_name} - #{@report_range}",
        disposition: 'attachment',
        template: "shared/teacher/_attendance_report.html.erb",
        layout: 'pdf.html.erb',
        javascript_delay: 2000,
        viewport_size: '1200x880',
        zoom: 0.9,
        margin:  {
                    top: 25,
                    bottom: 20
                },
        header: {
                  html: {
                          template: 'shared/pdfs/header',
                          layout: 'pdf_plain',
                          locals: {heading: "Teacher Attendance Report", left_tag: @report_range}
                        },
                  line: true,
                  spacing: 1
                },
        footer: {
                  html: {
                          template:'shared/pdfs/footer',
                          layout:  'pdf_plain',
                          locals: {left_tag: @report_range}
                        },
                  spacing: 1,
                  line:  true
                }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:first_name, :last_name, :email, :avatar, :phone, :qualification, :address, :profession)
    end

    def bulk_teacher_params
      params.permit(teachers: [:first_name, :last_name, :email, :avatar, :phone, :qualification, :address, :profession])[:teachers]
    end
end
