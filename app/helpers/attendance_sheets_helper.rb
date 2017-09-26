module AttendanceSheetsHelper
  def edit_path(sheet)
    current_user.teacher? ? managing_students_attendance_sheets_path(date: sheet.name, section_id: sheet.section.id) : managing_students_administrator_attendance_sheets_path(date: sheet.name, section_id: sheet.section.id)
  end

  def destroy_path(sheet)
    current_user.teacher? ? attendance_sheet_path(sheet) : administrator_attendance_sheet_path(sheet)
  end

  def activate_latest_month(attendance_sheets, index)
    'active' if attendance_sheets.length == index + 1
  end

  def activate_latest_month_entry(attendance_sheets, month)
    'hidden' unless month == attendance_sheets.keys.first
  end
end
