class Api::V1::Teacher::TeacherBaseController < Api::V1::BaseController
  before_action :ensure_teacher

  private

  def ensure_teacher
    return unauthorized_response("Invalid Access") unless current_user.teacher?
  end
end
