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
