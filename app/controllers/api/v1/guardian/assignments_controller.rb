class Api::V1::Guardian::AssignmentsController < Api::V1::Guardian::GuardianBaseController
  before_action :set_section, only: [:index, :show]
  before_action :set_assignment, only: [:show]

  def index
    @assignments = Assignment.of_section(@section.id).includes(:subject, :teacher, section: :klass).ordered
    render json: @assignments
  end

  def show
    render json: @assignment, serializer: AssignmentSerializer
  end

  private
    def set_section
      @section = selected_user.current_section(current_term.id)
    end

    def set_assignment
      @assignment = Assignment.find(params[:id])
      return unauthorized_response("Invalid Access") if @assignment.section_id != @section.id
    end
end

