class Api::V1::Guardian::GuardianBaseController < Api::V1::BaseController
  before_action :ensure_guardian
  before_action :ensure_selected_student

  private

  def ensure_guardian
    return unauthorized_response("Invalid Access") unless current_user.guardian?
  end

  def ensure_selected_student
    @selected_student = Student.find(params[:student_id])

    return unauthorized_response("Invalid Access") unless @selected_student.id.in?(current_user.children.pluck(:id))
  end
end
