module Attendance
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def get_initial_report_dates(current_term)
      start_date =  current_term.end_date.beginning_of_month
      end_date = current_term.end_date
      if Date.today.between?(current_term.start_date, current_term.end_date)
        start_date = Date.today
        end_date = Date.today.beginning_of_month
      end
      temp_start_date = current_term.end_date.beginning_of_month
      start_date = temp_start_date if start_date < current_term.start_date
      end_date = current_term.end_date if current_term.end_date < end_date
      [start_date.to_s, end_date.to_s]
    end
  end
end
