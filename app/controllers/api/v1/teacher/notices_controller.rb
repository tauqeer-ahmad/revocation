module Api
  module V1
    module Teacher
      class NoticesController < TeacherBaseController
        def index
          @notices = Notice.lookup(params[:search], {includes: [:klass, :section], order: {updated_at: :desc}, where: where_clause, page: params[:page], per_page: Notice::DEFAULT_PER_PAGE})

          render json: @notices
        end

        private
          def where_clause
            { notice_type: Notice::TEACHER_TYPES }
          end
      end
    end
  end
end
