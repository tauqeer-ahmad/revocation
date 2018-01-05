class Api::V1::Teacher::AssignmentsController < Api::V1::Teacher::TeacherBaseController
  before_action :set_section, only: [:index, :show]
  before_action :set_assignment, only: [:show]

  def index
    @assignments = Assignment.of_section(@section.id).includes(:subject, :teacher, section: :klass).ordered
    render json: @assignments
  end

  def show
    render json: @assignment, serializer: AssignmentDetailSerializer
  end

  private
    def set_section
      return unauthorized_response("Invalid Access") if params[:section_id].blank?

      @section = Section.find params[:section_id]
      return unauthorized_response("Invalid Access") unless @section.try(:id).in?(current_user.sections.pluck(:id))
    end

    def set_assignment
      @assignment = Assignment.find(params[:id])
      return unauthorized_response("Invalid Access") if @assignment.section_id != @section.id
    end
end
