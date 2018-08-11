class Teacher::DiaryNotesController < ApplicationController
  before_action :validate_term, only: [:edit, :new, :create, :update, :destroy]
  before_action :set_diary_note, only: [:edit, :update, :destroy, :show]
  before_action :set_class_section_subject, only: [:index, :edit, :new]
  before_action :set_students, only: [:edit, :new]

  def index
    @diary_notes = current_user.diary_notes.of_section(@section.id).of_subject(@subject.id).ordered
    @diary_note = DiaryNote.new(section_id: @section.id, subject_id: @subject.id)
  end

  def new
    @diary_note = DiaryNote.new(section_id: @section.id, subject_id: @subject.id)
  end

  def edit
  end

  def create
    @diary_note = DiaryNote.new(diary_notes_params)

    if @diary_note.save
      redirect_to sections_path, notice: 'Note was successfully updated.'
    else
      redirect_to sections_path, error: @diary_note.errors.full_messages.to_sentence
    end
  end

  def update
    if @diary_note.update(diary_notes_params)
      redirect_to sections_path, notice: 'Note was successfully updated.'
    else
      set_class_section_subject
      set_students
      render :edit
    end
  end

  def destroy
    @diary_note.destroy
    respond_to do |format|
      format.html { redirect_to "/diary_notes_path/#{@diary_note.section_id}/#{@diary_note.subject_id}", notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show
  end

  private
    def set_diary_note
      @diary_note = current_user.diary_notes.find(params[:id])
    end

    def diary_notes_params
      params.require(:diary_note).permit(:heading, :note_for, :note, :subject_id, :section_id, :student_id).tap do |whitelisted|
        whitelisted[:teacher_id] = current_user.id
        whitelisted[:term_id] = current_term.id
      end
    end

    def set_class_section_subject
      @section = Section.find(params[:section_id] || @diary_note.section_id)
      @klass = @section.klass
      @subject = Subject.find(params[:subject_id] || @diary_note.subject_id)

      redirect_to sections_path, error: 'Invalid Access.' unless current_user.validate_section_and_subject(@section, @subject)
    end

    def set_students
      @students = @section.students
    end
end
