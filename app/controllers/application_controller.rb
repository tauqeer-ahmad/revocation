class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :user_signed_in?, :current_institute, :current_term
  
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
  
  def current_institute
    if current_teacher.present?
      @current_institute ||= current_teacher.institution
    elsif current_administrator.present?
      @current_institute = current_administrator.institution
    elsif current_student.present?
      @current_institute ||= current_student
    elsif current_guardian.present?
      @current_institute ||= current_guardian
    elsif current_admin_supervisor.present?
      @current_institute ||= current_admin_supervisor
    end
  end
  
  def current_term
    if current_teacher.present?
      @current_term ||= current_institute.terms.last
    elsif current_administrator.present?
      @current_term ||= current_institute.terms.last
    elsif current_student.present?
      @current_term ||= current_institute.terms.last
    elsif current_guardian.present?
      @current_term ||= current_institute.terms.last
    end
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
end
