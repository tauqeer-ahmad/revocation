bind_diary_note_view_modal_box = ->
  $('body').on 'click', '.add-diary-note-modal', (event) ->
    $('#diary-modal #diary_note_section_id').val($(this).data('section'))
    $('#diary-modal #diary_note_subject_id').val($(this).data('subject'))

(($) ->
  window.DiaryNote || (window.DiaryNote = {})

  DiaryNote.init = ->
    init_controls()

  init_controls = ->
    bind_diary_note_view_modal_box()
).call(this)
