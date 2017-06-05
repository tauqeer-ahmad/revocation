set_attendance_calendar = ->
  if $('#calendar').length
    $('#calendar').fullCalendar
      header:
        left: ''
        center: 'title'
        right: 'prev,next'
      firstDay: 1
      showNonCurrentDates: false
      contentHeight: 400
      events: gon.events

$ ->
  set_attendance_calendar()
