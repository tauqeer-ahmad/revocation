class Api::V1::Guardian::HomeController < Api::V1::Guardian::GuardianBaseController
  before_action :validate_selected_student, only: :select_student

  def select_student
    session[:selected_student] = params[:selected_student]

    success_response("Student switched successfully.")
  end

  private

  def validate_selected_student
    return unauthorized_response("Invalid Access") unless params[:selected_student].to_i.in? current_user.children.pluck(:id)
  end
end
