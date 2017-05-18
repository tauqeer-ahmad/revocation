module ApplicationHelper
    def is_active_controller(controller_name)
      params[:controller] == controller_name ? 'active' : nil
    end

    def is_active_action(action_name)
      params[:action] == action_name ? 'active' : nil
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
end
