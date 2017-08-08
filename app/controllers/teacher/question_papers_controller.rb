class Teacher::QuestionPapersController < ApplicationController
  before_action :set_question_paper, only: [:edit, :update, :destroy]
  before_action :set_edit_objects, only: [:edit]

  def index
    @question_papers = current_user.question_papers.of_term(current_term.id).includes(:teacher, :subject, :klass, :section, :exam, :term)
    @klasses = current_user.my_klasses
    @sections, @subjects = [], []
    @exams = current_term.exams.pluck(:name, :id)
  end

  def new
    @question_paper = QuestionPaper.new
    @klasses = current_user.my_klasses
    @sections, @subjects = [], []
    @exams = current_term.exams.pluck(:name, :id)
  end

  def edit
  end

  def create
    @question_paper = QuestionPaper.new(question_paper_params)

    if @question_paper.save
      redirect_to question_papers_path, notice: 'Question Paper was successfully Added.'
    else
      redirect_to question_papers_path, error: @question_paper.errors.full_messages.to_sentence
    end
  end

  def update
    if @question_paper.update(question_paper_params)
      redirect_to question_papers_path, notice: 'Question Paper was successfully updated.'
    else
      set_edit_objects
      render :edit
    end
  end

  def destroy
    @question_paper.destroy
    respond_to do |format|
      format.html { redirect_to question_papers_path, notice: 'Question Paper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_question_paper
      @question_paper = current_user.question_papers.find(params[:id])
    end

    def question_paper_params
      params.require(:question_paper).permit(:klass_id, :section_id, :subject_id, :exam_id, :content).tap do |whitelisted|
        whitelisted[:teacher_id] = current_user.id
        whitelisted[:term_id] = current_term.id
      end
    end

    def set_edit_objects
      @klasses = current_user.my_klasses
      @sections = SectionSubjectTeacher.includes(:section).term_teacher_klass(current_term.id, current_user.id, @question_paper.klass.id).collect(&:section_option).uniq
      @subjects = SectionSubjectTeacher.includes(:subject).term_teacher_section(current_term.id, current_user.id, @question_paper.section.id).collect &:subject_option
      @exams = current_term.exams.pluck(:name, :id)
    end
end
