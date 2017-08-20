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
end
