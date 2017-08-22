class Teacher::AccountsController < ApplicationController
  before_action :ensure_params, only: [:update]

  def show
  end

  def update
    @user = Teacher.find(current_user.id)
    if @user.update(teacher_params)
      redirect_to account_path, notice: "Your avatar has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  def update_password
    @user = Teacher.find(current_user.id)
    if @user.update_with_password(teacher_password_params)
      sign_in(:teacher, @user, bypass: true)
      redirect_to account_path, notice: "Your password has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  private
    def teacher_password_params
      params.require(:teacher).permit(:current_password, :password, :password_confirmation)
    end

    def teacher_params
      params.require(:teacher).permit(:avatar)
    end

    def ensure_params
      if params[:teacher].blank?
        flash[:alert] = "No image selected"
        render :show
      end
    end
end
