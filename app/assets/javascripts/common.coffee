@animate_contact_box = ->
  $('.contact-box').each ->
    animationHover this, 'pulse'

@enable_ichecks = ->
  $('.i-checks').iCheck
    checkboxClass: 'icheckbox_square-green'
    radioClass: 'iradio_square-green'
    disabledClass: 'disabled'

@enable_autocomplete = (route) ->
  engine = new Bloodhound(
    datumTokenizer: (d) ->
      Bloodhound.tokenizers.whitespace d.search
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: "..#{route}/autocomplete?search=%QUERY"
      wildcard: '%QUERY')

  promise = engine.initialize()

  promise.done(->
    console.log 'success!'
  ).fail ->
    console.log 'error!'

  $('.typeahead').typeahead { minLength: 3 },
    name: 'search'
    displayKey: 'search'
    source: engine.ttAdapter()

  $('body').on 'click', '.tt-suggestion', (event) ->
    $('#search-box').closest("form").submit()

@validate_field = ->
  return unless $('.validate-field').length

  $('.validate-field').on 'blur', ->
    current_field = $(this)
    current_field.parent().append("<span class='help-block text-danger hide'></span>") unless current_field.siblings('span').length
    span_field = current_field.siblings('span')
    form = $(this).parents('form')
    model_name = $(this).data('model')
    field_name = $(this).data('field')
    field_value = current_field.val()

    if field_value.length > 0
      $.ajax
        url: '/validate_field'
        type: 'POST'
        dataType: 'json'
        data:
          model: model_name
          attribute: field_name
          value: field_value
        success: (data) ->
          if data['message']
            form.find('*[type="submit"]').prop('disabled', true)
            current_field.addClass('error-field')
            span_field.text([field_name.capitalize(), data['message']].join(' '))
            span_field.removeClass('hide')
          else
            form.find('*[type="submit"]').prop('disabled', false)
            current_field.removeClass('error-field')
            span_field.addClass('hide')

bind_conversation_scroll = ->
  if $('.chat-message').length
    $('.chat-message').last()[0].scrollIntoView(false);

bind_ajax_requests_props = ->
  $('a[data-remote]').on 'ajax:beforeSend', (e, data, status, xhr) ->
    # If needed.
  $('a[data-remote]').on 'ajax:success', (e, data, status, xhr) ->
    $('[data-toggle="tooltip"]').tooltip()

bind_attendance_date_field = ->
  date = new Date()
  today = new Date(date.getFullYear(), date.getMonth(), date.getDate());
  $('.attendance-date-field').datepicker
    format: 'dd-mm-yyyy'
    autoclose: true
    todayHighlight: true
  $('.attendance-date-field').datepicker('setDate', today)

$ ->
  validate_field()
  bind_conversation_scroll()
  bind_ajax_requests_props()
  bind_attendance_date_field()
