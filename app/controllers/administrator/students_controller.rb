class Administrator::StudentsController < ApplicationController
  before_action :set_section, only: [:new, :index, :edit, :create, :update, :show, :destroy, :update_section, :autocomplete, :bulk_view, :bulk_insert]
  before_action :set_student, only: [:show, :edit, :update, :destroy, :update_section, :results]

  def index
    @students = params[:search].present? ? Student.lookup(params[:search], {where: {section_id: @section.id}}) : @section.students
    @new_student = Student.new
    @valid_sections = @section.klass.sections.of_current_term(current_term.id).pluck(:name, :id).reject{|s| s.last == @section.id}
  end

  def show
    @klass = @section.klass
    @incharge = @section.incharge
    @guardian = @student.guardian
  end

  def new
    @student = Student.new(registration_number: Student.generate_registration_number(Institution.current, current_term))
  end

  def edit
  end

  def create
    @student = Student.new(student_params)
    @student.guardian_id ||= get_guardian_id

    respond_to do |format|
      if @student.save
        @section.section_students.create!(student_id: @student.id, klass_id: @section.klass_id, term_id: current_term.id, roll_number: params[:student][:roll_number])
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
    @student.reload
    @student.save
    respond_to do |format|
      format.html { redirect_to administrator_section_students_url(@section), notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def bulk_view
  end

  def bulk_insert
    Student.transaction do
      students_and_sections = []

      bulk_student_params.each do |student_params|
        student_params[:guardian_id] ||= Guardian.create(student_params[:guardian]).id
        student = Student.where(email: student_params[:email]).first_or_create(student_params.except(:guardian))

        students_and_sections << {
          student_id: student.id,
          klass_id: @section.klass_id,
          term_id: current_term.id,
          roll_number: student.roll_number
        }
      end

      @section.section_students.create!(students_and_sections)
    end

    redirect_to administrator_section_students_path(@section)
  end

  def update_section
    valid_section_ids = @section.klass.sections.of_current_term(current_term.id).ids - [@section.id]
    return redirect_to administrator_section_students_path(@section), alert: "Student transfer only allowed within current class sections." unless params[:new_section_id].to_i.in?(valid_section_ids)
    SectionStudent.where(section_id: @section.id, student_id: @student.id).update(section_id: params[:new_section_id])
    redirect_to administrator_section_students_path(@section), notice: 'Student transfer was successfully completed.'
  end

  def results
    @exam_marks = @student.exam_marks.includes(:subject, :klass, :section).group_by(&:exam_id)
    @all_exam_marks = ExamMark.where(section_id: @student.sections.ids).to_a
    @klass_marks = @all_exam_marks.group_by(&:klass_id)
    @section_marks = @all_exam_marks.group_by(&:section_id)
    @subject_marks = @all_exam_marks.group_by(&:subject_id)
    @exams = Exam.pluck(:id, :name).to_h
    render layout: false
  end

  def autocomplete
    render json: autocomplete_query(Student, ["first_name", "last_name"], {section_id: params[:section_id]}).map{|student| {search: [student.first_name, ' ', student.last_name].join}}
  end

  def lookup
    @klasses = Klass.all
    options = {}
    if params[:section_id].present?
      @section = Section.where(id: params[:section_id]).first
      options[:where] = {section_id: @section.id}
    end
    @students = []
    if options.present? || params[:keyword].present?
      @students = Student.lookup(params[:keyword], options)
    end
  end

  def perform_lookup
    @section = Section.where(id: params[:section_id]).first
    @students = Student.lookup('*', {where: {section_id: @section.id}})
  end

  private
    def get_guardian_id
      Guardian.where(email: guardian_params[:email]).first_or_create(guardian_params).id
    end

    def set_section
      @section = current_term.sections.find(params[:section_id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :email, :avatar, :roll_number, :guardian_id, :gender, :registration_number).tap do |whitelisted|
        whitelisted[:enrollment_term_id] = current_term.id
      end
    end

    def guardian_params
      return {} if params[:guardian].blank?
      params.require(:guardian).permit(:first_name, :last_name, :email, :cnic, :phone)
    end

    def bulk_student_params
      params.permit(students: [:first_name, :last_name, :email, :avatar, :roll_number, :guardian_id, :gender, guardian: [:first_name, :last_name, :cnic, :email, :phone]]).tap do |custom_params|
        custom_params[:students].each do |student|
          student[:enrollment_term_id] = current_term.id
        end
      end[:students]
    end
end
