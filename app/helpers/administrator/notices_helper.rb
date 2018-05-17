module Administrator::NoticesHelper
  def notice_class_hide(type)
    'hide' if type.in? ['General', 'Teacher', 'Guardian']
  end

  def notice_section_hide(type)
    'hide' unless type == 'Section Specific'
  end

  def select2_class(edit)
    'select2_dropdown' unless edit
  end

  def notice_path(notice)
    if notice.noticeable_type == 'Exam' && (current_user.student? || current_user.guardian?)
      exam_path(id: notice.noticeable_id)
    elsif notice.noticeable_type == 'Assignment' && (current_user.student? || current_user.guardian? || current_user.teacher?)
      assignment_path(id: notice.noticeable_id)
    else
      return '#'
    end
  end

  def notice_view(notice)
    path = notice_path(notice)

    return link_to(path, class: 'btn btn-outline btn-success dim btn-xs'){ icon_of('fa fa-eye') } unless path == '#'
    return link_to('#', class: 'btn btn-outline btn-success dim btn-xs', data: { toggle: 'modal', target: "#notice-modal-#{notice.id}" }){ icon_of('fa fa-eye') }
  end

  def get_col_class(current_user)
    return "col-xs-7" if current_user.administrator?
    "col-xs-9"
  end
end
