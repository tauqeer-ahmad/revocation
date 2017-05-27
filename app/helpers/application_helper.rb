module ApplicationHelper
    def is_active_controller(controller_name)
      params[:controller] == controller_name ? 'active' : nil
    end

    def is_active_action(controller_name, action_name)
      params[:action] == action_name && params[:controller] == controller_name ? 'active' : nil
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
    value.strftime('%d/%m/%Y%l-%M %p') if value
  end
end
