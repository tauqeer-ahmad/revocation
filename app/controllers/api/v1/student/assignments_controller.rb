class Api::V1::Student::AssignmentsController < Api::V1::Student::StudentBaseController
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
      @section = current_user.current_section(current_term.id)
    end

    def set_assignment
      @assignment = Assignment.find(params[:id])
      return unauthorized_response("Invalid Access") if @assignment.section_id != @section.id
    end
end
