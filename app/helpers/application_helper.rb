module ApplicationHelper
    def is_active_controller(controller_name)
        params[:controller] == controller_name ? "active" : nil
    end

    def is_active_action(action_name)
        params[:action] == action_name ? "active" : nil
    end
    
    def get_logout_path(user)
      case user.type_of
      when 'Administrator'
        destroy_administrator_session_path
      when 'Teacher'
        destroy_teacher_session_path
      when 'Student'
        destroy_student_session_path
      when 'Parent'
        destroy_parent_session_path
      end
    end
end
