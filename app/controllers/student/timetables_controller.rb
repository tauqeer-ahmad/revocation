class Student::TimetablesController < ApplicationController
  def index
    @section = current_student.current_section(current_term.id)
    @timetables = @section.timetables.by_day_of_week
  end
end
