set_timetable_calendar = ->
  if $('#timetable-calendar').length
    $('#timetable-calendar').fullCalendar
      header:
        left: ''
        center: ''
        right: ''
      defaultView: 'agendaWeek'
      minTime: '06:00:00'
      maxTime: '22:00:00'
      height: 680
      columnFormat: 'dddd'
      slotDuration: '00:30:00'
      allDaySlot: false
      firstDay: 1
      displayEventTime: true
      events: gon.timetable_events
      eventClick: (calEvent, jsEvent, view) ->
        jsEvent.stopPropagation();
        $('#period-options').removeClass('hide')
                            .offset({top: jsEvent.pageY, left: jsEvent.pageX})
                            .html(build_options_ul(calEvent.id, calEvent.color, calEvent.teacher_id, calEvent.teacher_name, calEvent.section_id))

        $('#period-options ul.dropdown-menu').css('display', 'block')

build_options_ul = (period_id, color, teacher_id, teacher_name, section_id) ->
  "<ul class='dropdown-menu'>
    <li>
      <a onmouseover=\"this.style.backgroundColor='#{color}', this.style.color='#fff'\" onmouseout=\"this.style.backgroundColor='#fff', this.style.color='#676a6c'\" href=\"/administrator/teachers/#{teacher_id}\" style=\"background-color: rgb(255, 255, 255); color: rgb(103, 106, 108);\">
        <i class='entypo-trash'></i> #{teacher_name}
      </a>
    </li>

    <li>
     <a onmouseover=\"this.style.backgroundColor='#{color}', this.style.color='#fff'\" onmouseout=\"this.style.backgroundColor='#fff', this.style.color='#676a6c'\" href=\"/administrator/sections/#{section_id}/timetables/#{period_id}/edit\">
        <i class='fa fa-pencil-square-o'></i> Edit
      </a>
    </li>

    <li>
      <a onmouseover=\"this.style.backgroundColor='#{color}', this.style.color='#fff'\" onmouseout=\"this.style.backgroundColor='#fff', this.style.color='#676a6c'\" data-behavior=\"delete\" data-object=\"Period\" href=\"/administrator/sections/#{section_id}/timetables/#{period_id}\">
        <i class='fa fa-trash-o'></i> Delete
      </a>
    </li>
  </ul>"

reset_options_ul = ->
  $('body').on 'click', ->
    $('#period-options').html('')

(($) ->
  window.Timetable || (window.Timetable = {})

  Timetable.init = ->
    init_controls()

  init_controls = ->
    set_timetable_calendar()
    reset_options_ul()
).call(this)
