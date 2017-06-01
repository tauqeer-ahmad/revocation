bind_options_modal = ->
  $('.term-box').click ->
    $("#term-modal-#{$(this).data('term-id')}").modal('toggle')

(($) ->
  window.AdministratorTerm || (window.AdministratorTerm = {})

  AdministratorTerm.init = ->
    init_controls()

  init_controls = ->
    bind_options_modal()
).call(this)
