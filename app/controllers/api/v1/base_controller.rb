class Api::V1::BaseController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :require_login

  respond_to :json

  def error_response(message, errors={})
    response = {message: message}
    response.merge!({errors: errors}) if errors.present?
    render status: :unprocessable_entity, json: response
  end

  def success_response(message)
    render status: :success, json: { message: message }
  end

 def current_user
    @current_user ||= authenticate_token
  end

  def require_login
    authenticate_token || render_unauthorized("Unauthorized access")
  end

  protected

  def render_unauthorized(message)
    render json: {message: message}, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      user = User.find_by(access_token: token)
      user if user && Devise.secure_compare(user.access_token, token)
    end
  end
end
