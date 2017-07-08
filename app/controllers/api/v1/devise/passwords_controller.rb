class Api::V1::Devise::PasswordsController < Api::V1::BaseController
  skip_before_action :require_login, only: [:create, :update]

  # POST /resource/password
  def create
    resource_class = User.get_resource_and_key_name(request.fullpath)
    resource = resource_class.send_reset_password_instructions(resource_params)

    if resource.errors.empty?
      render json: {message: "You will receive an email to reset your password."}
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  # PUT /resource/password
  def update
    resource_class = User.get_resource_and_key_name(request.fullpath)
    resource = resource_class.reset_password_by_token(resource_params)

    if resource.errors.empty?
      resource.regenerate_access_token
      render json: resource, serializer: LoginSuccessSerializer, subdomain: request.subdomain
    else
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  protected
    def resource_params
      params.fetch(:user)
    end
end
