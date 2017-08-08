class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?, :current_term, :active_term, :selected_student
  before_action :check_locked_account
  before_action :set_notices
  before_action :latest_notices

  add_flash_types :error
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

  def selected_student
    return @selected_student if @selected_student && @selected_student.id == session[:selected_student]

    @selected_student = session[:selected_student] ? Student.find(session[:selected_student]) : current_user.children.first
  end

  def selected_user
    current_user.type_of == 'Guardian' ? selected_student : current_user
  end

  def allocate_term
    session[:selected_term] ? Term.find(session[:selected_term]) : Term.active_term
  end

  def current_term
    @current_term ||= allocate_term
  end

  def active_term
    @active_term ||= Term.active_term
  end

  def user_signed_in?
    current_teacher.present? || current_administrator.present? || current_student.present? || current_guardian.present? || current_admin_supervisor.present?
  end

  def set_notices
    return if current_user.blank?

    @new_notices_count = Notice.new_notice_count(selected_user, active_term, current_user.type_of)
  end

  def latest_notices
    return if current_user.blank?

    @latest_notices = Notice.latest_notices(selected_user, active_term, current_user.type_of)
  end

  private
    def layout_by_resource
      if devise_controller?
        'empty'
      else
        'application'
      end
    end

    def check_locked_account
      if session[:lock_account] == true && !action_name.in?(['unlock_account', 'lock_account']) && !devise_controller?
        return redirect_to(lock_account_path), notice: 'Please, unlock you account first!'
      end
    end
end
