class Api::V1::BaseController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :require_login

  respond_to :json

  def error_response(message, errors={})
    response = {message: message}
    response.merge!({errors: errors}) if errors.present?
    render status: :unprocessable_entity, json: response.to_json
  end

  def success_response(message)
    render json: { message: message }.to_json, status: :ok
  end

  def unauthorized_response(message)
    render json: {message: message}.to_json, status: :unauthorized
  end

 def current_user
    @current_user ||= authenticate_token
  end

  def require_login
    authenticate_token || render_unauthorized("Unauthorized access")
  end

  def current_term
    @current_term ||= Term.active_term
  end
  
  def record_not_found
    render json: { message: 'Record not found' }, status: 404
  end

  protected

  def render_unauthorized(message)
    render json: {message: message}.to_json, status: :unauthorized
  end

  private

  def authenticate_token
    authenticate_with_http_token do |token, options|
      user = User.find_by(access_token: token)
      user if user && Devise.secure_compare(user.access_token, token)
    end
  end
end
