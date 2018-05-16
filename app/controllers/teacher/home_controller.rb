class Teacher::HomeController < ApplicationController
  layout 'empty', only: [:lock_account]

  def index
    @rolling = {
      sections: current_user.sections.count,
      subject_schedules: current_user.subject_schedules.count,
      assignments: current_user.assignments.count,
      question_papers: current_user.question_papers.count,
    }
    gon.timetable_events = current_user.subject_timetable_events(current_term)
    gon.attendance_events = []
    gon.assignment_events = Assignment.teacher_assignment_events(current_user, current_term)
    gon.exam_events       = Exam.exam_teacher_events(current_user, current_term)
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

  def global_search
    @results = Teacher.search(params['global_search'], index_name: current_user.global_search_models)
  end
end
