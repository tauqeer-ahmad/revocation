class Student::HomeController < ApplicationController
  def index
    gon.attendance_events = Attendance.attendance_events(current_user, current_term)

    gon.assignment_events = Assignment.assignment_events(current_user, current_term)

    gon.exam_events       = Exam.exam_events(current_user, current_term)
  end
end
