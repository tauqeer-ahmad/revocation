class Guardian::HomeController < ApplicationController
  layout 'empty', only: [:lock_account]

  before_action :validate_selected_student, only: :select_student

  def index
    gon.attendance_events = Attendance.attendance_events(selected_student, current_term)

    gon.assignment_events = Assignment.assignment_events(selected_student, current_term)

    gon.exam_events       = Exam.exam_events(selected_student, current_term)
  end

  def select_student
    session[:selected_student] = params[:selected_student]

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def lock_account
    session[:lock_account] = true
  end

  def unlock_account
    if current_user.valid_password?(params[:password])
      session[:lock_account] = false
      flash[:notice] = 'Successfully unlocked your account!'
    else
      flash[:alert] = 'You entered incorrect password!'
    end

    redirect_to root_path
  end

  private
    def validate_selected_student
      return head(:bad_request) unless params[:selected_student].to_i.in? current_user.children.pluck(:id)
    end
end
