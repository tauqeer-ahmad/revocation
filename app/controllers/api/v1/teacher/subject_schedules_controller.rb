module Api
  module V1
    module Teacher
      class SubjectSchedulesController < TeacherBaseController
        def index
          render json: current_user.subject_schedules.where(section_id: params[:section_id])
        end
      end
    end
  end
end
