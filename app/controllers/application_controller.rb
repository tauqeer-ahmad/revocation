class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?, :current_term
  before_action :check_locked_account

  layout :layout_by_resource

  def current_user
    if current_teacher.present?
      @current_user ||= current_teacher
    elsif current_administrator.present?
      @current_user ||= current_administrator
    elsif current_student.present?
      @current_user ||= current_student
    elsif current_guardian.present?
      @current_user ||= current_guardian
    elsif current_admin_supervisor.present?
      @current_user ||= current_admin_supervisor
    end
  end

  def allocate_term
    session[:selected_term] ? Term.find(session[:selected_term]) : Term.active_term
  end

  def current_term
    @current_term ||= allocate_term
  end

  def user_signed_in?
    current_teacher.present? || current_administrator.present? || current_student.present? || current_guardian.present? || current_admin_supervisor.present?
  end

  private
    def layout_by_resource
      if devise_controller?
        "devise"
      else
        "application"
      end
    end

    def check_locked_account
      if session[:lock_account] == true && !action_name.in?(['unlock_account', 'lock_account']) && !devise_controller?
        return redirect_to(lock_account_path), notice: 'Please, unlock you account first!'
      end
    end
end
