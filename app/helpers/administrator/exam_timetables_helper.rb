module Administrator::ExamTimetablesHelper
  def format_paper_date(date)
    date.to_date.strftime("%d %B, %Y")
  end
end
