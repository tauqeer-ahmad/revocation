class Api::V1::Student::StudentBaseController < Api::V1::BaseController
  before_action :ensure_student

  private

  def ensure_student
    return unauthorized_response("Invalid Access") unless current_user.student?
  end
end
