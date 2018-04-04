class TeacherAttendance < ApplicationRecord
  include SearchWrapper
  include SearchCallbackableWithoutParanoia
  include Attendance

  belongs_to :term
  belongs_to :teacher

  scope :of_day, -> (date) {where(day: date)}
  scope :ordered, -> {order(teacher_id: :asc)}
  scope :of_term, -> (term_id) { where(term_id: term_id) }

  searchkick index_name: tenant_index_name

  def search_data
    {
      day: day,
      teacher_id: teacher_id,
      term_id: term_id,
    }
  end

  def self.for_month_and_year(month, year)
    return if month.blank? || year.blank?

    date = Date.new(year.to_i, month.to_i)

    where('day >= ? AND day <= ?', date.beginning_of_month, date.end_of_month)
  end

  def display_status
    case status
      when 'present' then 'P'
      when 'absent' then 'A'
      when 'leave' then 'L'
    end
  end

  def self.fetch_report_data(params, current_term)
    attendances = []
    where_clause = {term_id: current_term.id}
    start_date = params[:start_range]
    end_date = params[:end_range]

    if start_date.blank? && end_date.blank?
      start_date, end_date = get_initial_report_dates(current_term)
    end

    if start_date.present? && end_date.present?
      teachers = Teacher.ordered
      start_range, end_range = TeacherAttendance.get_report_dates(start_date, end_date)
      where_clause[:day] = start_range...end_range
      attendances = TeacherAttendance.lookup '', {where: where_clause, order: {day: :asc}}
    end

    month_statistics = {}
    month_late_statistics = {}
    month_grouped = attendances.group_by { |m| m.day.beginning_of_month }
    formated_results = {}
    key_to_dates = {}
    month_grouped.each_with_index do |(month, records), index|
      key = [Date::MONTHNAMES[month.month], month.year].join('-')
      key_to_dates[key] = {start_date: month.beginning_of_month, end_date: month.end_of_month}
      if start_range.to_date == end_range.to_date
        key = [start_range.strftime("%d %b, %Y")]
        key_to_dates[key] = {start_date: start_range, end_date: end_range}
      elsif month.month == start_range.month && end_range.month == month.month
        key = [start_range.strftime("%d %b, %Y"), end_range.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: start_range, end_date: end_range}
      elsif month.month == start_range.month && end_range.month != month.month
        key = [start_range.strftime("%d %b, %Y"), month.end_of_month.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: start_range, end_date: month.end_of_month}
      elsif month.month == end_range.month
        key = [month.beginning_of_month.strftime("%d %b, %Y"), end_range.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: month.beginning_of_month, end_date: end_range}
      end

      teacher_grouped = records.group_by(&:teacher_id)
      formated_results[key] = teacher_grouped
      month_statistics[key] = {Present: 0, Absent: 0, Leave: 0} if month_statistics[key].blank?
      month_late_statistics[key] = {"On Time" => 0, Late: 0} if month_late_statistics[key].blank?
      total_present = 0
      records.group_by(&:status).map{ |status, r| month_statistics[key][status.capitalize.to_sym] = calculate_percentage(r.count, records.count); total_present += r.count if status == "present"; r.select{|r| month_late_statistics[key][:Late] += 1 if r.late?}}
      month_late_statistics[key]["On Time"] = (total_present - month_late_statistics[key][:Late])
      month_late_statistics[key]["On Time"] = calculate_percentage(month_late_statistics[key]["On Time"], total_present)
      month_late_statistics[key][:Late] = calculate_percentage(month_late_statistics[key][:Late], total_present)
    end
    [formated_results, key_to_dates, month_statistics, month_late_statistics, attendances, start_range, end_range, teachers]
  end

  def self.fetch_pdf_report_data(start_date, end_date, current_term)
    where_clause = {term_id: current_term.id}
    attendances = []
    teachers = []
    if start_date.present? && end_date.present?
      teachers = Teacher.ordered
      where_clause[:day] = start_date...end_date
      attendances = TeacherAttendance.lookup '', {where: where_clause, order: {day: :asc}}
    end

    report_statistics =  {Present: 0, Absent: 0, Leave: 0}
    report_late_statistics = {"On Time" => 0, Late: 0}
    total_present = 0
    attendances.group_by(&:status).map{ |status, r| report_statistics[status.capitalize.to_sym] = calculate_percentage(r.count, attendances.count); total_present += r.count if status == "present"; r.select{|r| report_late_statistics[:Late] += 1 if r.late?}}
    report_late_statistics["On Time"] = (total_present - report_late_statistics[:Late])
    report_late_statistics["On Time"] = calculate_percentage(report_late_statistics["On Time"], total_present)
    report_late_statistics[:Late] = calculate_percentage(report_late_statistics[:Late], total_present)
    attendances = attendances.group_by(&:teacher_id)

    report_range = [start_date.strftime("%d %B, %Y"), end_date.strftime("%d %B, %Y")].join(' - ')
    [attendances, report_statistics, report_late_statistics, report_range, teachers]
  end

  def self.fetch_teacher_report_data(params, current_term, teacher)
    attendances = []
    where_clause = {term_id: current_term.id, teacher_id: teacher.id}
    start_date = params[:start_range]
    end_date = params[:end_range]

    if start_date.blank? && end_date.blank?
      start_date, end_date = get_initial_report_dates(current_term)
    end
    start_range, end_range = TeacherAttendance.get_report_dates(start_date, end_date)
    where_clause[:day] = start_range...end_range
    attendances = TeacherAttendance.lookup '', {where: where_clause, order: {day: :asc}}
    report_range = [start_range.strftime("%d %B, %Y"), end_range.strftime("%d %B, %Y")].join(' - ')

    month_statistics = {}
    month_late_statistics = {}
    month_grouped = attendances.group_by { |m| m.day.beginning_of_month }
    formated_results = {}
    key_to_dates = {}
    month_grouped.each_with_index do |(month, records), index|
      key = [Date::MONTHNAMES[month.month], month.year].join('-')
      key_to_dates[key] = {start_date: month.beginning_of_month, end_date: month.end_of_month}
      if start_range.to_date == end_range.to_date
        key = [start_range.strftime("%d %b, %Y")]
        key_to_dates[key] = {start_date: start_range, end_date: end_range}
      elsif month.month == start_range.month && end_range.month == month.month
        key = [start_range.strftime("%d %b, %Y"), end_range.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: start_range, end_date: end_range}
      elsif month.month == start_range.month && end_range.month != month.month
        key = [start_range.strftime("%d %b, %Y"), month.end_of_month.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: start_range, end_date: month.end_of_month}
      elsif month.month == end_range.month
        key = [month.beginning_of_month.strftime("%d %b, %Y"), end_range.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: month.beginning_of_month, end_date: end_range}
      end

      formated_results[key] = records
      month_statistics[key] = {Present: 0, Absent: 0, Leave: 0} if month_statistics[key].blank?
      month_late_statistics[key] = {"On Time" => 0, Late: 0} if month_late_statistics[key].blank?
      total_present = 0
      records.group_by(&:status).map{ |status, r| month_statistics[key][status.capitalize.to_sym] = calculate_percentage(r.count, records.count); total_present += r.count if status == "present"; r.select{|r| month_late_statistics[key][:Late] += 1 if r.late?}}
      month_late_statistics[key]["On Time"] = (total_present - month_late_statistics[key][:Late])
      month_late_statistics[key]["On Time"] = calculate_percentage(month_late_statistics[key]["On Time"], total_present)
      month_late_statistics[key][:Late] = calculate_percentage(month_late_statistics[key][:Late], total_present)
    end
    [formated_results, key_to_dates, month_statistics, month_late_statistics, attendances, report_range, start_date, end_date]
  end

  def search_name
    self.teacher.full_name
  end

  def self.get_report_dates(start_date, end_date)
    [Date.parse(start_date).beginning_of_day, Date.parse(end_date).end_of_day]
  end

  def self.calculate_percentage(value, total)
    return 0.0 if total.zero?
    ((value.to_f/total.to_f)*100).round(1)
  end
end
