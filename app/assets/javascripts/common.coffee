@animate_contact_box = ->
  $('.contact-box').each ->
    animationHover this, 'pulse'

@enable_ichecks = ->
  $('.i-checks').iCheck
    checkboxClass: 'icheckbox_square-green'
    radioClass: 'iradio_square-green'

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
            current_field.addClass('error-field')
            span_field.text([field_name.capitalize(), data['message']].join(' '))
            span_field.removeClass('hide')
          else
            current_field.removeClass('error-field')
            span_field.addClass('hide')

$ ->
  validate_field()
