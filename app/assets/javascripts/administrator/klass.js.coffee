bind_sortable = ->
  $('*[data-role=activerecord_sortable]').activerecord_sortable();

(($) ->
  window.AdminKlass || (window.AdminKlass = {})

  AdminKlass.init = ->
    init_controls()

  init_controls = ->
    bind_sortable()
).call(this)
