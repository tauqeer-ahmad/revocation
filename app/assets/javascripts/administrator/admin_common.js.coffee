@bind_datepicker = ->
  $('body').on 'focus', '.datepicker', ->
    $(this).datetimepicker
      format: 'DD/MM/YYYY'
      showTodayButton: true
      sideBySide: true
      widgetPositioning:
        horizontal: 'left'
        vertical: 'bottom'
    $(this).on 'dp.hide', (e) ->
      form = $(this).parents('form[data-client-side-validations]')
      if form.length > 0
        $(this).data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)

@bind_datetimepicker = ->
  $('body').on 'focus', '.datetimepicker', ->
    $(this).datetimepicker
      format: 'DD/MM/YYYY LT'
      widgetPositioning:
        horizontal: 'left'
        vertical: 'bottom'
    $(this).on 'dp.hide', (e) ->
      form = $(this).parents('form[data-client-side-validations]')
      if form.length > 0
        $(this).data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)

@bind_timepicker = ->
  $('body').on 'focus', '.timepicker', ->
    $(this).datetimepicker
      format: 'LT'
    $(this).on 'dp.hide', (e) ->
      form = $(this).parents('form[data-client-side-validations]')
      if form.length > 0
        $(this).data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)

@js_bind_timepicker =->
  $('input.timepicker').datetimepicker
    format: 'LT'

@bind_client_side_validations = ->
  $(document).on 'focus', "*[data-client-side-validations]", ->
    $(this).enableClientSideValidations()
$ ->
  bind_datepicker()
  bind_datetimepicker()
  bind_timepicker()
  bind_client_side_validations()
