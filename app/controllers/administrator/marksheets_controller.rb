class Administrator::MarksheetsController < ApplicationController
  before_action :set_marksheet, only: [:show, :edit, :update, :destroy, :update_marksheet]

  def index
    @exams = Exam.of_current_term(current_term.id)
    @klasses = Klass.all
  end

  def build_marksheet
    @section = Section.find(params[:section_id])
    @students = @section.students
    @exam = Exam.find(params[:exam_id])
    @subject = Subject.find(params[:subject_id])
    @klass = @section.klass
    @marksheet = Marksheet.existing_marksheet(current_term.id, params[:exam_id], params[:klass_id], params[:section_id], params[:subject_id]).first
    if @marksheet.present?
      @exam_marks = @marksheet.exam_marks
      new_students = @students.pluck(:id) - @exam_marks.pluck(:student_id)
      new_students.each do |student_id|
        @exam_marks << @marksheet.exam_marks.build(obtained: nil, student_id: student_id, klass_id: params[:klass_id], section_id: params[:section_id], exam_id: params[:exam_id], subject_id: params[:subject_id])
      end
    end

    respond_to do |format|
      format.js
      format.xlsx {
        response.headers['Content-Disposition'] = "attachment; filename=\"#{@section.klass_name} - #{@section.name} - #{@report_range}.xlsx\""
      }
      format.pdf do
        @teacher = @section.section_subject_teachers.where(subject_id: @subject.id).last.teacher
        render pdf: "Marksheet #{@section.klass.name}-#{@section.name}-#{@exam.name}",
        disposition: 'attachment',
        template: "administrator/marksheets/marksheet_pdf.html.erb",
        layout: 'pdf.html.erb',
        javascript_delay: 500,
        viewport_size: '595x842',
        zoom: 0.9,
        margin:  {
                    top: 25,
                    bottom: 20
                },
        header: {
                  html: {
                          template: 'shared/pdfs/header',
                          layout: 'pdf_plain',
                          locals: {heading: "Marksheet", left_tag: @section.name}
                        },
                  line: true,
                  spacing: 1
                },
        footer: {
                  html: {
                          template:'shared/pdfs/footer',
                          layout:  'pdf_plain',
                          locals: {left_tag: "Created At: #{Time.now.strftime('%d %B %Y %l-%M %p')}"}
                        },
                  spacing: 1,
                  line:  true
                }
      end
    end
  end

  def create_marksheet
    @marksheet = Marksheet.create(marksheet_params)
    ExamMark.create(marks_params)
    redirect_to administrator_marksheets_path(klass_id: @marksheet.klass_id, section_id: @marksheet.section_id, exam_id: @marksheet.exam_id, subject_id: @marksheet.subject_id), notice: "Marksheet has been updated successfully"
  end

  def update_marksheet
    @marksheet.update(exam_mark_params)
    redirect_to administrator_marksheets_path(klass_id: @marksheet.klass_id, section_id: @marksheet.section_id, exam_id: @marksheet.exam_id, subject_id: @marksheet.subject_id), notice: "Marksheet has been updated successfully"
  end

  def edit
    @exam_marks = @marksheet.exam_marks
  end

  def destroy
    @marksheet.destroy
    respond_to do |format|
      format.html { redirect_to administrator_marksheets_path, notice: 'Exam mark was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tabulation_sheet
    @klasses = Klass.all
    @klass_id = params[:klass_id]
    @section_id = params[:section_id]

    @results = []

    if params[:section_id].present?
      @section = Section.includes(:subjects).find(params[:section_id])
      @results = @section.create_tabulation_sheet
    end
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
