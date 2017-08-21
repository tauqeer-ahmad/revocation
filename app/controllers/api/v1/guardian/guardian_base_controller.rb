class Api::V1::Guardian::GuardianBaseController < Api::V1::BaseController
  before_action :ensure_guardian

  private

  def ensure_guardian
    return unauthorized_response("Invalid Access") unless current_user.guardian?
  end
end
