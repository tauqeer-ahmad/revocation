@bind_material_datepicker = ->
  date = new Date()
  today = moment(date).format('DD MMMM YYYY')
  $('body').on 'focus', '.material_datepicker', ->
    $(this).bootstrapMaterialDatePicker
      format: 'DD MMMM YYYY'
      currentDate: today
      switchOnClick: true
      maxDate: today
      time: false
      date: true
      weekStart : 1
      nowButton: true
      nowText: 'Today'
      okText: "Select"
  $('.material_datepicker').val(today).change();

@bind_material_timepicker = ->
  $('body').on 'focus', '.material_timepicker', ->
    $(this).bootstrapMaterialDatePicker
      format: 'LT'
      time: true
      date: false
      weekStart : 1
      shortTime: true
      okText: "Select"
      switchOnClick: true

@bind_datepicker = ->
  $('body').on 'focus', '.datepicker', ->
    $(this).datetimepicker
      format: 'DD MMMM YYYY'
      sideBySide: true
      minDate: gon.start_date
      maxDate: gon.end_date
      widgetPositioning:
        vertical: 'bottom'
    $(this).on 'dp.hide', (e) ->
      form = $(this).parents('form[data-client-side-validations]')
      if form.length > 0
        $(this).data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)

@bind_datetimepicker = ->
  $('body').on 'focus', '.datetimepicker', ->
    $(this).datetimepicker
      format: 'DD MMMM YYYY LT'
      widgetPositioning:
        vertical: 'bottom'
    $(this).on 'dp.hide', (e) ->
      form = $(this).parents('form[data-client-side-validations]')
      if form.length > 0
        $(this).data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)

@bind_timepicker = ->
  $('body').on 'focus', '.timepicker', ->
    $(this).datetimepicker
      format: 'LT'
      widgetPositioning:
        vertical: 'bottom'
    $(this).on 'dp.hide', (e) ->
      form = $(this).parents('form[data-client-side-validations]')
      if form.length > 0
        $(this).data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)

@js_bind_timepicker =->
  $('input.timepicker').datetimepicker
    format: 'LT'
    widgetPositioning:
      vertical: 'bottom'

@bind_client_side_validations = ->
  $(document).on 'focus', "*[data-client-side-validations]", ->
    $(this).enableClientSideValidations()
    ClientSideValidations.formBuilders['NestedForm::Builder'] = ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'];

$ ->
  bind_datepicker()
  bind_datetimepicker()
  bind_timepicker()
  bind_client_side_validations()
  bind_material_datepicker()
  bind_material_timepicker()
