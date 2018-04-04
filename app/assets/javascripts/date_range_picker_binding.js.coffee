set_range_picker_value = (start, end) ->
  $('#reportrange span').html start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY')
  $('.start_range').attr('value', start.format('YYYY-MM-DD'))
  $('.end_range').attr('value', end.format('YYYY-MM-DD'))
  return

bind_predefined_range_picker = ->
  start = moment(gon.start_date)
  start = moment(gon.end_date).startOf('month') if moment(gon.end_date).startOf('month') >= moment(gon.start_date)
  end = moment(gon.end_date)

  start_range = $('.start_range').val()
  end_range = $('.end_range').val()

  if start_range
    start = moment(start_range)

  if end_range
    end = moment(end_range)

  $('#reportrange').daterangepicker {
    startDate: start
    endDate: end
    showDropdowns: true
    minDate: gon.start_date
    maxDate: gon.end_date
    ranges:
      'Today': [
        moment()
        moment()
      ]
      'Yesterday': [
        moment().subtract(1, 'days')
        moment().subtract(1, 'days')
      ]
      'Last 30 Days': [
        moment().subtract(29, 'days')
        moment()
      ]
      'This Month': [
        moment().startOf('month')
        moment().endOf('month')
      ]
      'Last Month': [
        moment().subtract(1, 'month').startOf('month')
        moment().subtract(1, 'month').endOf('month')
      ]
  }, set_range_picker_value
  set_range_picker_value start, end

$(window).load ->
  bind_predefined_range_picker()
