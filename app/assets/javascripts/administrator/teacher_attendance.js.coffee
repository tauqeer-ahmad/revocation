bind_late_check_box = ->
  $('body').on 'ifChecked', '.attendance_radio', ->
    late_checkbox = $($(this).data('lateCheckboxClass'))
    late_checkbox.iCheck('enable')
    return
  $('body').on 'ifUnchecked', '.attendance_radio', ->
    late_checkbox = $($(this).data('lateCheckboxClass'))
    late_checkbox.iCheck('disable')
    return

bind_date_change = ->
  $('body').on 'dp.change', '.teacher_attendance_datepicker', ->
    console.log "heller"

(($) ->
  window.TeacherAttendance || (window.TeacherAttendance = {})

  TeacherAttendance.init = ->
    init_controls()

  init_controls = ->
    bind_late_check_box()
    bind_date_change()
).call(this)
