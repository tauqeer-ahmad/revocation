module Api
  module V1
    module Teacher
      class AssignmentsController < TeacherBaseController
        before_action :set_section, only: [:index, :show]
        before_action :set_assignment, only: [:show]

        def index
          @assignments = Assignment.of_section(@section.id).includes(:subject, :teacher, section: :klass).ordered

          render json: @assignments, scope: { include_task: false }
        end

        def show
          render json: @assignment, scope: { include_task: true }
        end

        private
          def set_section
            @section = current_user.sections.find(params[:section_id])
          end

          def set_assignment
            @assignment = @section.assignments.find(params[:id])
          end
      end
    end
  end
end
