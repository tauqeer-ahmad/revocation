class Student::AccountsController < ApplicationController
  before_action :ensure_params, only: [:update]

  def show
  end

  def update
    @user = Student.find(current_user.id)
    if @user.update(student_params)
      redirect_to account_path, notice: "Your avatar has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render "show"
    end
  end

  def update_password
    @user = Student.find(current_user.id)
    if @user.update_with_password(student_password_params)
      sign_in(:student, @user, :bypass => true)
      redirect_to account_path, notice: "Your password has been updated successfully"
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render "show"
    end
  end

  private
    def student_password_params
      params.require(:student).permit(:current_password, :password, :password_confirmation)
    end

    def student_params
      params.require(:student).permit(:avatar)
    end

    def ensure_params
      if params[:student].blank?
        flash[:alert] = "No image selected"
        render "show"
      end
    end
end
