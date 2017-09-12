class Api::V1::Guardian::StudentsController < Api::V1::Guardian::GuardianBaseController
  skip_before_action :ensure_selected_student

  def index
    @students = current_user.children
    render json: @students, each_serializer: ChildSerializer
  end
end
