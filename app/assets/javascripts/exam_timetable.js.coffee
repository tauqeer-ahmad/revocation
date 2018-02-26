bind_nested_form_error = ->
  ClientSideValidations.formBuilders['NestedForm::Builder'] = ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'];
(($) ->
  window.ExamEditTimetable || (window.ExamEditTimetable = {})

  ExamEditTimetable.init = ->
    init_controls()

  init_controls = ->
    load_sections(default_parent())
    bind_exam_klass_section_change()
    bind_nested_form_error()
).call(this)
