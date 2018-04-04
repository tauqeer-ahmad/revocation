module Attendance
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def get_initial_report_dates(current_term)
      start_date = current_term.start_date.to_s
      temp_start_date = current_term.end_date.beginning_of_month
      start_date = temp_start_date.to_s if temp_start_date >= current_term.start_date
      end_date = current_term.end_date.to_s
      [start_date, end_date]
    end
  end
end
