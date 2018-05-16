class Teacher::TimetablesController < ApplicationController
  before_action :set_section

  def index
    @timetable_objects = @section.timetables
    @timetables = @timetable_objects.by_day_of_week
    gon.timetable_events = Timetable.events(@timetables)
    @new_timetable = Timetable.new
    @days_hash = Timetable::DAYS
  end

  private

  def set_section
    @section = Section.find(params[:section_id])
  end
end
