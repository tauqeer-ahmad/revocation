class Student::HomeController < ApplicationController
  layout 'empty', only: [:lock_account]

  def index
    gon.attendance_events = StudentAttendance.attendance_events(current_user, current_term)

    gon.assignment_events = Assignment.assignment_events(current_user, current_term)

    gon.exam_events       = Exam.exam_events(current_user, current_term)
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
end
