module AttendanceSheetsHelper
  def edit_path(sheet)
    current_user.teacher? ? managing_students_teacher_attendance_sheets_path(date: sheet.name, section_id: sheet.section.id) : managing_students_administrator_attendance_sheets_path(date: sheet.name, section_id: sheet.section.id)
  end

  def destroy_path(sheet)
    current_user.teacher? ? teacher_attendance_sheets_path(sheet) : administrator_attendance_sheets_path(sheet)
  end
end
