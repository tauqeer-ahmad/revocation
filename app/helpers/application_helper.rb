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
    value && value.strftime('%d/%m/%Y%l-%M %p')
  end

  def datepicker_default_value(value)
    value && value.strftime('%d/%m/%Y')
  end

  def icon_of(klass, text = '')
    content_tag :span do
      concat content_tag(:i, '', class: klass)
      concat text
    end
  end

  def calculate_percentage(value, total)
    return 0.0 if total.zero?
    ((value.to_f / total) * 100).round(1)
  end

  def calculate_average(values, count)
    return 0.0 if count.zero?
    (values.to_f/count.to_f).round(1)
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
end
