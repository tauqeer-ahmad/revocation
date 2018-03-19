bind_late_check_box = ->
  $('body').on 'ifChecked', '.attendance_radio', ->
    late_checkbox = $($(this).data('lateCheckboxClass'))
    late_checkbox.iCheck('enable')
    return
  $('body').on 'ifUnchecked', '.attendance_radio', ->
    late_checkbox = $($(this).data('lateCheckboxClass'))
    late_checkbox.iCheck('disable')
    return

(($) ->
  window.StudentAttendance || (window.StudentAttendance = {})

  StudentAttendance.init = ->
    init_controls()

  init_controls = ->
    bind_late_check_box()
).call(this)
