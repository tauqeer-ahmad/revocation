class Student::TimetablesController < ApplicationController
  def index
    @section = selected_user.current_section(current_term.id)
    @timetables = @section.timetables.by_day_of_week
    gon.timetable_events = Timetable.events(@timetables)
  end
end
