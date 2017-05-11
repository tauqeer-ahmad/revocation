class Administrator::StudentsController < ApplicationController
  before_action :set_section
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  def index
    @students = @section.students
    @new_student = Student.new
    @guardians = Guardian.all
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)
    password = SecureRandom.hex(8)
    @student.password = password
    @student.enrollment_term_id = current_term.id

    respond_to do |format|
      if @student.save
        @section.section_students.create!(student_id: @student.id, klass_id: @section.klass_id, term_id: current_term.id, roll_number: params[:student][:roll_number])
        StudentMailer.send_password(@student, Institution.current, password).deliver!
        format.html { redirect_to administrator_section_students_url(@section), notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @student.attributes = student_params
    if @student.roll_number_changed?
      SectionStudent.where(section_id: @section.id, student_id: @student.id).update({roll_number: @student.roll_number})
    end
    respond_to do |format|
      if @student.save
        format.html { redirect_to administrator_section_students_url(@section), notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to administrator_section_students_url(@section), notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_insert
    Student.create(bulk_student_params)
    redirect_to administrator_section_students_path(@section)
  end


  private
    def set_section
      @section = current_term.sections.find(params[:section_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :email, :avatar, :roll_number, :guardian_id, :gender)
    end

    def bulk_student_params
      params.permit(students: [:first_name, :last_name, :email, :avatar, :roll_number, :guardian_id, :gender])[:students]
    end
end
