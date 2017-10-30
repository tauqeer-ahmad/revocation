$('.list-view').html('<%= j render "shared/attendance_sheets/managing_students", { path: attendance_sheet_path(@attendance_sheet) } %>')
