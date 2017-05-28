class Administrator::MarksheetsController < ApplicationController
  before_action :set_marksheet, only: [:show, :edit, :update, :destroy, :update_marksheet]

  def index
    @exams = Exam.of_current_term(current_term.id)
    @klasses = Klass.all
  end

  def existing
    @marksheets = Marksheet.lookup params[:search], {term_id: current_term.id}
    #@marksheets = Marksheet.includes(:exam, :klass, :subject, :section, exam_marks: [:student]).of_current_term(current_term.id)
  end

  def build_marksheet
    @marksheet = Marksheet.existing_marksheet(current_term.id, params[:exam_id], params[:klass_id], params[:section_id], params[:subject_id]).first
    if @marksheet.present?
      @exam_marks = @marksheet.exam_marks
    else
      @exam = Exam.find(params[:exam_id])
      @subject = Subject.find(params[:subject_id])
      @section = Section.find(params[:section_id])
      @klass = @section.klass
      @students = @section.students
    end
  end

  def create_marksheet
    @marksheet = Marksheet.create(marksheet_params)
    ExamMark.create(marks_params)
    redirect_to existing_administrator_marksheets_path, notice: "Marksheet has been updated successfully"
  end

  def update_marksheet
    @marksheet.update(exam_mark_params)
    redirect_to existing_administrator_marksheets_path, notice: "Marksheet has been updated successfully"
  end

  def edit
    @exam_marks = @marksheet.exam_marks
  end

  def destroy
    @marksheet.destroy
    respond_to do |format|
      format.html { redirect_to existing_administrator_marksheets_path, notice: 'Exam mark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def generate_tabulation_sheet
    @exams = Exam.of_current_term(current_term.id)
    @klasses = Klass.all
  end

  def tabulation_sheet
    @klass = Klass.find(params[:klass_id])
    @section = Section.includes(:subjects).find(params[:section_id])
    @subjects = @section.subjects
    @exam = Exam.find(params[:exam_id])
    @exam_marks = ExamMark.by_klass_section_exam(params[:exam_id], params[:klass_id], params[:section_id]).includes(:subject).group_by(&:student_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_marksheet
      @marksheet = Marksheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exam_mark_params
      params[:marksheet][:exam_marks_attributes].each do |key, values|
        params[:marksheet][:exam_marks_attributes][key] = values.merge!({total: params[:total], passing_marks: params[:passing_marks]})
      end
       params.require(:marksheet).permit(exam_marks_attributes: [:id, :obtained, :comment, :total, :passing_marks])
    end

    def marksheet_params
      params.permit(:exam_id, :klass_id, :section_id, :subject_id).tap do |whitelisted|
        whitelisted[:term_id] = current_term.id
      end
    end

    def marks_params
      params.permit(students: [:obtained, :comment, :student_id])[:students].each do |mark_data|
        mark_data.tap do |whitelisted|
          whitelisted[:term_id] = current_term.id
          whitelisted[:klass_id] = params[:klass_id]
          whitelisted[:exam_id] = params[:exam_id]
          whitelisted[:section_id] = params[:section_id]
          whitelisted[:subject_id] = params[:subject_id]
          whitelisted[:total] = params[:total]
          whitelisted[:passing_marks] = params[:passing_marks]
          whitelisted[:marksheet_id] = @marksheet.id
        end
      end
    end
end
