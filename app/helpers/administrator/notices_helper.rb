module Administrator::NoticesHelper
  def notice_class_hide(type)
    'hide' if type == 'General'
  end

  def notice_section_hide(type)
    'hide' unless type == 'Section Specific'
  end

  def notice_class_disable(type)
    type == 'General'
  end

  def notice_section_disable(type)
    type != 'Section Specific'
  end
end
