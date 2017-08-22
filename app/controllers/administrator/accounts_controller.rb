class Administrator::AccountsController < ApplicationController
  before_action :ensure_params, only: [:update]

  def show
  end

  def update
    @user = Administrator.find(current_user.id)
    if @user.update(administrator_params)
      redirect_to account_path, notice: "Your avatar has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  def update_password
    @user = Administrator.find(current_user.id)
    if @user.update_with_password(administrator_password_params)
      sign_in(:administrator, @user, bypass: true)
      redirect_to account_path, notice: "Your password has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  private
    def administrator_password_params
      params.require(:administrator).permit(:current_password, :password, :password_confirmation)
    end

    def administrator_params
      params.require(:administrator).permit(:avatar)
    end

    def ensure_params
      if params[:administrator].blank?
        flash[:alert] = "No image selected"
        render :show
      end
    end
end
