$('.list-view').html('<%= j render "shared/attendance_sheets/managing_students", { path: administrator_attendance_sheet_path(@attendance_sheet) } %>')
enable_ichecks();
