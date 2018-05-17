module ApplicationHelper
  def is_active_controller(controller_name)
    params[:controller] == controller_name ? 'active' : nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? 'active' : nil
  end

  def is_active_controller_action(controller_name, action_name)
    is_active_controller(controller_name) && is_active_action(action_name)
  end

  def get_logout_path(user)
    case user.type_of
    when 'Administrator'
      destroy_administrator_session_path
    when 'Teacher'
      destroy_teacher_session_path
    when 'Student'
      destroy_student_session_path
    when 'Guardian'
      destroy_guardian_session_path
    when 'Supervisor'
      destroy_admin_supervisor_session_path
    end
  end

  def admin_show_path(entity)
    case entity.class.name
    when 'Student'
      administrator_section_student_path(entity.current_section(current_term), entity.id)
    when 'Teacher'
      administrator_teacher_path(entity)
    when 'Guardian'
      administrator_guardian_path(entity)
    when 'Klass'
      administrator_klasses_path(entity)
    when 'Subject'
      administrator_subject_path(entity)
    when 'Exam'
      administrator_exam_path(entity)
    end
  end

  def teacher_show_path(entity)
    return '#'

    case entity.class.name
    when 'Student'
      section_student_path(entity.current_section(current_term), entity.id)
    when 'Teacher'
      teacher_path(entity)
    when 'Guardian'
      guardian_path(entity)
    when 'Klass'
      klasses_path(entity)
    when 'Subject'
      subject_path(entity)
    when 'Exam'
      exam_path(entity)
    end
  end

  def show_path(entity)
    current_user.administrator? ? admin_show_path(entity) : teacher_show_path(entity)
  end

  def tab_item(name, url)
    opts = {}
    content_tag :li, opts do
      link_to name, url
    end
  end

  def klass_submit_name(action_name)
    keyword = action_name == 'index' && 'Create' || 'Update'
    [keyword, 'Class'].join(' ')
  end

  def flash_class(level)
    case level.to_sym
      when :notice then 'success'
      when :success then 'success'
      when :error then 'error'
      when :alert then 'error'
    end
  end

  def format_date(date)
    date.to_date.strftime("%d %B, %Y")
  end

  def time_format(t)
    t.in_time_zone.strftime('%-I:%M %p') if t
  end

  def render_time(t, format=nil)
    if t
      if format
        case format
        when :full
          if t < Time.now.beginning_of_year
            t.in_time_zone.strftime('%-d %b %Y %-I:%M %p')
          else
            t.in_time_zone.strftime('%-d %b %-I:%M %p')
          end
        when :long
          t.in_time_zone.strftime('%-d %b %Y at %-I:%M.%S %p')
        when :short
          if t > Time.zone.today
            t.in_time_zone.strftime('%-I:%M %p')
          elsif t > 3.days.ago
            t.in_time_zone.strftime('%a, %-I:%M %p')
          else
            t.in_time_zone.strftime('%-d %b %Y')
          end
        when :date_only
          t.in_time_zone.strftime('%-d %B, %Y')
        else
          t.in_time_zone.strftime(format)
        end
      else
        t.in_time_zone.strftime('%-d %b %Y %-I:%M %p')
      end
    end
  end

  def datetimepicker_default_value(value)
    value && value.strftime('%d %B %Y %l-%M %p')
  end

  def datepicker_default_value(value)
    value && value.strftime('%d %B %Y')
  end

  def timepicker_default_value(value)
    value && value.strftime('%l:%M %p')
  end

  def icon_of(klass, text = '')
    content_tag :span do
      concat content_tag(:i, '', class: klass)
      concat text
    end
  end

  def calculate_percentage(value, total)
    return 0.0 if total.zero?
    '%.1f' % ((value.to_f / total) * 100)
  end

  def calculate_average(values, count)
    return 0.0 if count.zero?
    '%.1f' % (values.to_f/count.to_f)
  end

  def display_collective_average(groud_id, term_id, exam_id, objects)
    return 0.0 if objects.blank?
    entries = objects[groud_id].group_by(&:term_id)[term_id].group_by(&:exam_id)[exam_id]
    total_sum = entries.sum(&:obtained)
    number_of_students = entries.collect(&:student_id).uniq.size
    calculate_average(total_sum, number_of_students)
  end

  def notice_index_link(user)
    if user.administrator?
      administrator_notices_path
    else
      notices_path
    end
  end

  def entity_status(entity)
    entity.initialized? ? 'Publish' : 'DeActivate'
  end

  def entity_status_class(entity)
    entity.initialized? ? 'btn-primary' : 'btn-warning'
  end


  def term_switch_base_path
    current_user.administrator? ? '/administrator/terms' : '/terms'
  end

  def select_result_header_class(index)
    return "result-even-header" if index.even?
    "result-odd-header"
  end

  def select_result_subheader_class(index)
    return "result-even-subheader" if index.even?
    "result-odd-subheader"
  end

  def message_class_with_outline(administrator)
    current_user == administrator && 'btn btn-success dim btn-xs invisible' || 'btn btn-outline btn-success dim btn-xs'
  end

  def get_obtained_marks(exams)
    return "-" if exams.blank?
    exams.collect(&:obtained).sum
  end

  def get_total_marks(exams)
    return "-" if exams.blank?
    exams.collect(&:total).sum
  end

  def get_actual_marks(exams)
    return "-" if exams.blank?
    exams.collect(&:actual_obtained).sum
  end

  def assign_grade(percentage, grade_mappings)
    return "-" if grade_mappings.blank?
    grade = grade_mappings.select {|x| x === percentage.to_f}.values.first
    return grade if grade.present?
    "F"
  end

  def prettify_users(users)
    users.map do |x|
      [x.name_and_role, x.id]
    end
  end

  def get_result_path(current_user, student, section={})
    return results_administrator_student_path(student) if current_user.administrator?
    return results_section_student_path(section, student) if current_user.teacher?
  end

  def get_result_report_path(current_user, student, format, section={})
    return results_report_administrator_student_path(student, format: format) if current_user.administrator?
    return results_report_section_student_path(section, student, format: format) if current_user.teacher?
  end

  def single_teacher_attendance_report_link(start_range, end_range, format, teacher = {})
    return attendance_administrator_teacher_path(teacher, format: format, start_range: start_range, end_range: end_range) if current_user.administrator?
    return attendances_path(format: format, start_range: start_range, end_range: end_range) if current_user.teacher?
  end

  def display_section_incharge(section, current_user)
    if section.incharge_id != current_user.id
      content_tag(:span, class: 'label label-primary') do
        section.incharge_name
      end
    else
      content_tag(:span, class: 'label label-success') do
        "You"
      end
    end
  end

  def display_total_tagline(current_page, total_count, page_count, per_page)
    displayed = 0
    if page_count > 0
      displayed = current_page.nil? || current_page.to_i == 0 ? page_count.to_i : ((current_page.to_i - 1) * per_page.to_i) + page_count.to_i
    end
    "Showing #{displayed} of #{total_count}"
  end
end
