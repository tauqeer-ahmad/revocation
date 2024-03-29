class StudentAttendance < ApplicationRecord
  include SearchWrapper
  include SearchCallbackableWithoutParanoia
  include Attendance

  belongs_to :section
  belongs_to :student
  belongs_to :klass
  belongs_to :term

  scope :of_day, -> (date) {where(day: date)}
  scope :ordered, -> {order(student_id: :asc)}
  scope :of_student_and_term, -> (student_id, term_id) { where(student_id: student_id, term_id: term_id) }

  searchkick index_name: tenant_index_name

  def search_data
    {
      day: day,
      klass_name: klass.name,
      klass_id: klass_id,
      student_id: student_id,
      section_id: section_id,
      section_name: section.name,
      sutdent_name: student.full_name,
      term_id: term_id,
    }
  end

  def self.for_month_and_year(month, year)
    if month.blank? || year.blank?
      date = Date.today
    else
      date = Date.new(year.to_i, month.to_i)
    end

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
    where_clause = {term_id: current_term.id}
    where_clause[:student_id] = params[:student_id] if params[:student_id].present?

    start_date = params[:start_range]
    end_date = params[:end_range]

    if start_date.blank? && end_date.blank?
      start_date, end_date = get_initial_report_dates(current_term)
    end

    if start_date.present? && end_date.present?
      start_range, end_range = StudentAttendance.get_report_dates(start_date, end_date)
      where_clause[:day] = start_range...end_range
    end

    section = if params[:section_id].present?
      where_clause[:section_id] = params[:section_id]
      Section.find(params[:section_id])
    end

    attendances = if params[:start_range].present? && params[:end_range].present?
      StudentAttendance.lookup '', { where: where_clause, order: { day: :asc } }
    else
      []
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

      student_grouped = records.group_by(&:student_id)
      formated_results[key] = student_grouped
      month_statistics[key] = {Present: 0, Absent: 0, Leave: 0} if month_statistics[key].blank?
      month_late_statistics[key] = {"On Time" => 0, Late: 0} if month_late_statistics[key].blank?
      total_present = 0
      records.group_by(&:status).map{ |status, r| month_statistics[key][status.capitalize.to_sym] = calculate_percentage(r.count, records.count); total_present += r.count if status == "present"; r.select{|r| month_late_statistics[key][:Late] += 1 if r.late?}}
      month_late_statistics[key]["On Time"] = (total_present - month_late_statistics[key][:Late])
      month_late_statistics[key]["On Time"] = calculate_percentage(month_late_statistics[key]["On Time"], total_present)
      month_late_statistics[key][:Late] = calculate_percentage(month_late_statistics[key][:Late], total_present)
    end

    [formated_results, key_to_dates, month_statistics, month_late_statistics, attendances, start_range, start_range, section]
  end

  def self.fetch_report_data_for_single(params, term_id, student_id)
    where_clause = {
      term_id: term_id,
      student_id: student_id,
    }
    current_term = Term.find(term_id)

    start_date = params[:start_range]
    end_date = params[:end_range]

    if start_date.blank? && end_date.blank?
      start_date, end_date = get_initial_report_dates(current_term)
    end

    start_range, end_range = StudentAttendance.get_report_dates(start_date, end_date)
    where_clause[:day] = start_range...end_range

    attendances = StudentAttendance.lookup '', { where: where_clause, order: { day: {unmapped_type: "long"} } }

    month_statistics = {}
    month_late_statistics = {}
    month_grouped = attendances.group_by { |m| m.day.beginning_of_month }
    formated_results = {}
    key_to_dates = {}

    month_grouped.each_with_index do |(month, records), index|
      key = [Date::MONTHNAMES[month.month], month.year].join('-')
      key_to_dates[key] = {start_date: month.beginning_of_month, end_date: month.end_of_month}
      if start_range.to_date == end_range.to_date
        key = [start_range.strftime('%d %b, %Y')]
        key_to_dates[key] = {start_date: start_range, end_date: end_range}
     elsif month.month == start_range.month && end_range.month == month.month
        key = [start_range.strftime("%d %b, %Y"), end_range.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: start_range, end_date: end_range}
      elsif month.month == start_range.month && end_range.month != month.month
        key = [start_range.strftime("%d %b, %Y"), month.end_of_month.strftime("%d %b, %Y")].join(' - ')
        key_to_dates[key] = {start_date: start_range, end_date: month.end_of_month}
      elsif month.month == end_range.month
        key = [month.beginning_of_month.strftime('%d %b, %Y'), end_range.strftime('%d %b, %Y')].join(' - ')
        key_to_dates[key] = {start_date: month.beginning_of_month, end_date: end_range}
      end

      student_grouped = records.group_by(&:student_id)
      formated_results[key] = student_grouped
      month_statistics[key] = { Present: 0, Absent: 0, Leave: 0 } if month_statistics[key].blank?
      month_late_statistics[key] = { 'On Time' => 0, Late: 0} if month_late_statistics[key].blank?
      total_present = 0
      records.group_by(&:status).map do |status, r|
        month_statistics[key][status.capitalize.to_sym] = calculate_percentage(r.count, records.count)
        total_present += r.count if status == "present"
        r.select { |r| month_late_statistics[key][:Late] += 1 if r.late? }
      end

      month_late_statistics[key]['On Time'] = (total_present - month_late_statistics[key][:Late])
      month_late_statistics[key]['On Time'] = calculate_percentage(month_late_statistics[key]['On Time'], total_present)
      month_late_statistics[key][:Late] = calculate_percentage(month_late_statistics[key][:Late], total_present)
    end

    [formated_results, key_to_dates, month_statistics, month_late_statistics, attendances, start_range, end_range]
  end

  def self.calculate_percentage(value, total)
    return 0.0 if total.zero?
    ((value.to_f/total.to_f)*100).round(1)
  end

  def self.fetch_pdf_report_data(start_date, end_date, section_id, current_term)
    where_clause = {term_id: current_term.id}
    if start_date.present? && end_date.present?
      where_clause[:day] = start_date...end_date
    end
    attendances = []
    if section_id.present?
      where_clause[:section_id] = section_id.to_i if section_id.present?
      section = Section.find(section_id)
      attendances = StudentAttendance.lookup '', {where: where_clause, order: {day: :asc}}
    end
    report_statistics =  {Present: 0, Absent: 0, Leave: 0}
    report_late_statistics = {"On Time" => 0, Late: 0}
    total_present = 0
    attendances.group_by(&:status).map{ |status, r| report_statistics[status.capitalize.to_sym] = calculate_percentage(r.count, attendances.count); total_present += r.count if status == "present"; r.select{|r| report_late_statistics[:Late] += 1 if r.late?}}
    report_late_statistics["On Time"] = (total_present - report_late_statistics[:Late])
    report_late_statistics["On Time"] = calculate_percentage(report_late_statistics["On Time"], total_present)
    report_late_statistics[:Late] = calculate_percentage(report_late_statistics[:Late], total_present)
    attendances = attendances.group_by(&:student_id)

    report_range = [start_date.strftime("%d %B, %Y"), end_date.strftime("%d %B, %Y")].join(' - ')
    [attendances, report_statistics, report_late_statistics, section, report_range]
  end

  def search_name
    "Student Attendance #{klass.name} - #{section.name}"
  end

  def self.get_report_dates(start_date, end_date)
    [Date.parse(start_date).beginning_of_day, Date.parse(end_date).end_of_day]
  end

  def get_attendance_color
    case status
      when 'present' then '#1ab394'
      when 'absent' then '#ed5565'
      when 'leave' then '#f8ac59'
    end
  end

  def self.attendance_events(current_user, current_term)
    attendances = self.of_student_and_term(current_user.id, current_term.id)

    attendances.collect do |attendance|
      {
        title: ['Attendance: ', attendance.status.capitalize].join,
        start: attendance.day.to_s,
        color: attendance.get_attendance_color,
        className: ['text-center', 'attendance-event'],
        allDay: true,
      }
    end
  end
end
