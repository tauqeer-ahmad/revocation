class Administrator::TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

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
