class Api::V1::Teacher::SectionsController < Api::V1::Teacher::TeacherBaseController
  before_action :set_section, only: [:tabulation_sheet]
  def index
    @sections = current_user.section_subject_teachers.of_term(current_term.id).includes(:subject, section: :klass)
    render json: @sections, root: :sections
  end

  def tabulation_sheet
    @results = @section.create_tabulation_sheet
    render json: @results, status: :ok
  end

  private
  def set_section
    @section = current_term.sections.where(id: params[:id]).last
    return record_not_found if @section.blank?
  end
end
