module Student::AttendanceHelper
  def display_attendance_status(status)
    content_tag(:span, shrink_status(status), class: status)
  end

  def shrink_status(status)
    case status
      when 'present' then 'P'
      when 'absent' then 'A'
      when 'leave' then 'L'
    end
  end
end
