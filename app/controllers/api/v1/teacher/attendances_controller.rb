module Api
  module V1
    module Teacher
      class AttendancesController < TeacherBaseController
        before_action :set_section, only: [:index]
        before_action :set_student, only: [:index]

        def index
          @attendances = @section.student_attendances
                                 .for_month_and_year(params[:month], params[:year])
                                 .of_student_and_term(@student.id, current_term.id)

          render json: @attendances
        end

        def myself
          @attendances = current_user.teacher_attendances.for_month_and_year(params[:month], params[:year]).of_term(1)

          render json: @attendances
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
