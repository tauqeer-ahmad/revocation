load_subjects = (parent) ->
  klass_id = parent.find('.selectable_exam_klass :selected').val()
  section_id = parent.find('.selectable_exam_section :selected').val()
  return false unless section_id
  subject_box = parent.find('.selectable_exam_subject')
  subject_box.empty()

  $.ajax "/administrator/classes/#{klass_id}/sections/#{section_id}/update_subjects",
    type: 'GET'
    dataType: 'json'
    data: []
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      subject_box.empty()
      i = 0
      while i < data.length
        subject_box.append(new Option(data[i].name, data[i].id))
        i++
      form = subject_box.parents('form[data-client-side-validations]')
      if form.length > 0
        subject_box.data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)
      selected = subject_box.data('selected')
      if selected
        subject_box.find("option[value=#{selected}]").prop('selected', true);

load_sections = (parent) ->
  klass_id = parent.find('.selectable_exam_klass :selected').val()
  return false unless klass_id
  klass_box = parent.find('.selectable_exam_klass')
  section_box = parent.find('.selectable_exam_section')
  subject_box = parent.find('.selectable_exam_subject')
  section_box.empty()
  subject_box.empty()

  $.ajax "/administrator/classes/#{klass_id}/update_sections",
    type: 'GET'
    dataType: 'json'
    data: []
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      section_box.empty()
      subject_box.empty()
      i = 0
      while i < data.length
        section_box.append(new Option(data[i].name, data[i].id))
        i++
      form = $(section_box).parents('form[data-client-side-validations]')
      if form.length > 0
        klass_box.data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)
        section_box.data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)
      selected = section_box.data('selected')
      if selected
        section_box.find("option[value=#{selected}]").prop('selected', true);
      load_subjects(parent)

bind_exam_klass_section_change = ->
  $('.selectable_exam_klass').change ->
      parent = $(this).parents('.selectable_parent')
      load_sections(parent)

  $('.selectable_exam_section').change ->
    parent = $(this).parents('.selectable_parent')
    load_subjects(parent)

(($) ->
  window.ExamTimetable || (window.ExamTimetable = {})

  ExamTimetable.init = ->
    init_controls()

  init_controls = ->
    load_sections(default_parent())
    bind_exam_klass_section_change()
).call(this)

default_parent = ->
  $('.selectable_parent')

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
