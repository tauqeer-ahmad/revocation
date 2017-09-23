module Administrator::MarksheetsHelper
  def display_obtained_marks(obtained, total)
    return "-" if obtained.blank?
    [obtained, total].join("/")
  end
end
