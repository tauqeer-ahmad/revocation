bind_time_table_view_btn = ->
  $('body').on 'click', '#exam-link', (event) ->
    $("#exam-modal .modal-content").html("");

(($) ->
  window.Exam || (window.Exam = {})

  Exam.init = ->
    init_controls()

  init_controls = ->
    bind_time_table_view_btn()
).call(this)
