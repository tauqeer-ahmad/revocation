module Administrator::MarksheetsHelper
  def disply_obtained_marks(obtained, total)
    return "-" if obtained.blank?
    [obtained, total].join("/")
  end
end
