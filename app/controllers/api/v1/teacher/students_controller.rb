module Api
  module V1
    module Teacher
      class StudentsController < TeacherBaseController
        before_action :set_section
        before_action :set_student, only: [:results]

        def index
          render json: @section.students.includes(:guardian)
        end

        def results
          render json: @student.results_json(current_term)
        end

        private
          def set_section
            @section = current_user.sections.find(params[:section_id])
          end

          def set_student
           @student = @section.students.find(params[:student_id])
          end
      end
    end
  end
end
