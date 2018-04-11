class Api::V1::Guardian::AssignmentsController < Api::V1::Guardian::GuardianBaseController
  before_action :set_section, only: [:index, :show]
  before_action :set_assignment, only: [:show]

  def index
    @assignments = Assignment.of_section(@section.id).includes(:subject, :teacher, section: :klass).ordered
    render json: @assignments
  end

  def show
    render json: @assignment, include_task: true
  end

  private
    def set_section
      @section = selected_user.current_section(current_term.id)
    end

    def set_assignment
      @assignment = @section.assignments.find(params[:id])
    end
end

