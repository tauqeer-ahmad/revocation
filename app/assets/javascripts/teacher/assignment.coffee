bind_assignment_view_modal_box = ->
  $('.add-assignment-modal').on 'click', ->
    $('#assignment-modal #assignment_section_id').val($(this).data('section'))
    $('#assignment-modal #assignment_subject_id').val($(this).data('subject'))

(($) ->
  window.Assignment || (window.Assignment = {})

  Assignment.init = ->
    init_controls()

  init_controls = ->
    bind_assignment_view_modal_box()
).call(this)
