set_attendance_calendar = ->
  if $('#calendar').length
    $('#calendar').fullCalendar
      header:
        left: ''
        center: 'title'
        right: 'prev,next'
      firstDay: 1
      showNonCurrentDates: false
      events: gon.attendance_events.concat(gon.assignment_events).concat(gon.exam_events)

$ ->
  set_attendance_calendar()
