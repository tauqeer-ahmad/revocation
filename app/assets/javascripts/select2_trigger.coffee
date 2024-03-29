init_select2 = ->
  $('.select-guardians').select2
    theme: 'bootstrap'
    placeholder: 'Select Guardian'
    width: '100%'
    minimumInputLength: 2
    ajax:
      url: '/administrator/guardians/fetch'
      cache: true
      dataType: 'json'
      type: 'GET'
      quietMillis: 50
      data: (term) ->
        keyword: term
      processResults: (data) ->
        results:  $.map(data, (item) ->
                    text: item[1]
                    id: item[0]
                  )

(($) ->
  window.Select2Trigger || (window.Select2Trigger = {})

  Select2Trigger.init = ->
    init_controls()

  init_controls = ->
    init_select2()
).call(this)
