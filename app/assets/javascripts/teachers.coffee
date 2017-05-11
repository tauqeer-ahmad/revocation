bind_add_row_bulk_insert = ->
  $('#add-row-btn').on 'click', ->
    form_row = $('#teachers-bulk-form #form-fields .whole-form').last().clone().appendTo('#teachers-bulk-form #form-fields')
    form_row.find('input').val('')

bind_delete_row_bulk_insert = ->
  $('body').on 'click', '.delete-row-btn', ->
    $('#form-fields .whole-form').length
    if $('#form-fields .whole-form').length == 1
      toastr.error('You cannot remove this!', 'Wake Up!')
    else
      $(this).parents('.whole-form').remove()

(($) ->
  window.Teacher || (window.Teacher = {})

  Teacher.init = ->
    init_controls()

  init_controls = ->
    bind_add_row_bulk_insert()
    bind_delete_row_bulk_insert()
).call(this)
