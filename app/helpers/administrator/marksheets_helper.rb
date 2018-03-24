module Administrator::MarksheetsHelper
  def display_obtained_marks(obtained, total)
    return "-" if obtained.blank?
    [obtained, total].join("/")
  end

  def display_absolute_marks(absolute)
    absolute.present? && absolute || '-'
  end

  def display_grade(grade)
    grade.present? && grade || '-'
  end

  def get_active_tab_class(index)
    return "active" if index == 0
  end
end
