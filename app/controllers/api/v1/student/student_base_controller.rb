class Api::V1::Student::StudentBaseController < Api::V1::BaseController
  before_filter :ensure_student

  private

  def ensure_student
    return unauthorized_response("Invalid Access") if current_user.class == "Student"
  end
end
