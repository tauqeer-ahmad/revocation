module Api
  module V1
    module Teacher
      class QuestionPapersController < TeacherBaseController
        def index
          render json: current_user.question_papers.where(section_id: params[:section_id])
        end
      end
    end
  end
end
