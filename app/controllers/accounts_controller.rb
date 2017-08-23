class AccountsController < ApplicationController
  before_action :authenticate_access!
  before_action :ensure_params, only: [:update]

  def show
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_password_params)
      redirect_to account_path, notice: "Your avatar has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_password_params)
      sign_in(user_type, @user, bypass: true)
      redirect_to account_path, notice: "Your password has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  private
    def user_password_params
      params.require(user_type).permit(:current_password, :password, :password_confirmation)
    end

    def user_params
      params.require(user_type).permit(:avatar)
    end

    def ensure_params
      if params[user_type].blank?
        flash[:alert] = "No image selected"
        render :show
      end
    end

    def user_type
      current_user.type_of.downcase.to_sym
    end
end
