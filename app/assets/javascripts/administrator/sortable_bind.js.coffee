bind_sortable = ->
  $('*[data-role=activerecord_sortable]').activerecord_sortable();

(($) ->
  window.Sortable || (window.Sortable = {})

  Sortable.init = ->
    init_controls()

  init_controls = ->
    bind_sortable()
).call(this)
