module Administrator::MarksheetsHelper
  def display_obtained_marks(obtained, total)
    return "-" if obtained.blank?
    [obtained, total].join("/")
  end

  def get_active_tab_class(index)
    return "active" if index == 0
  end
end
