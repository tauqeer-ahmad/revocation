bind_date_field = ->
  date = new Date()
  today = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  $('.date-field').datepicker
    format: 'dd-mm-yyyy'
    autoclose: true
    todayHighlight: true
  $('.date-field').datepicker('setDate', today)

bind_back_btn = ->
  $('body').on 'click', '#back-btn', (event) ->
    location.reload()

bind_month_selection = ->
  $('body').on 'click', '.month-selection', (event) ->
    month = $(this).attr('id')
    $('.attendance-row').addClass('hidden')
    $(".#{month}").removeClass('hidden')


(($) ->
  window.AttendanceSheet || (window.AttendanceSheet = {})

  AttendanceSheet.init = ->
    init_controls()

  init_controls = ->
    bind_date_field()
    bind_back_btn()
    bind_month_selection()
).call(this)
