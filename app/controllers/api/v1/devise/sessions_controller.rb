class Api::V1::Devise::SessionsController < Api::V1::BaseController
  skip_before_action :require_login, only: [:create]
  before_action :ensure_params_exist, only: [:create]

  def create
    resource_class = User.get_resource_and_key_name(request.fullpath)
    @user = resource_class.find_for_database_authentication(email: params[:user][:email])
    return invalid_login_attempt unless @user

    if @user.valid_password?(params[:user][:password])
      @user.regenerate_access_token
      render json: @user, serializer: LoginSuccessSerializer, subdomain: request.subdomain
    else
      invalid_login_attempt
    end
  end

  def destroy
    current_user.invalidate_token
    success_response("Successfully logged out.")
  end

  private
    def ensure_params_exist
      return unless params[:user].blank?
      error_response('Missing user parameters')
    end

    def invalid_login_attempt
      warden.custom_failure!
      render_unauthorized('Invalid login attempt')
    end
end
