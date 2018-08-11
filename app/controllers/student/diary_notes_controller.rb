class Student::DiaryNotesController < ApplicationController
  before_action :validate_section, only: [:index]

  def index
    @diary_notes = DiaryNote.for_section_and_student(params[:section_id], current_student.id)
                             .includes(:subject, section: :klass).ordered
                             .group_by { |notes| notes.subject }
  end

  private

    def validate_section
      @section = Section.find(params[:section_id])
      @klass = @section.klass

      redirect_to root_path, error: 'Invalid Access.' unless params[:section_id].to_i == selected_user.current_section(current_term.id).id
    end
end
