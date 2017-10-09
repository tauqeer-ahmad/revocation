load_subjects = ->
  klass_id = $('.selectable_exam_klass :selected').val()
  section_id = $('.selectable_exam_section :selected').val()
  return false unless section_id
  $('.selectable_exam_subject').empty()

  $.ajax "/administrator/classes/#{klass_id}/sections/#{section_id}/update_subjects",
    type: 'GET'
    dataType: 'json'
    data: []
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      $('.selectable_exam_subject').empty()
      i = 0
      while i < data.length
        $('.selectable_exam_subject').append(new Option(data[i].name, data[i].id))
        i++

load_sections = ->
  klass_id = $('.selectable_exam_klass :selected').val()
  return false unless klass_id
  $('.selectable_exam_section').empty()
  $('.selectable_exam_subject').empty()

  $.ajax "/administrator/classes/#{klass_id}/update_sections",
    type: 'GET'
    dataType: 'json'
    data: []
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      $('.selectable_exam_section').empty()
      $('.selectable_exam_subject').empty()
      i = 0
      while i < data.length
        $('.selectable_exam_section').append(new Option(data[i].name, data[i].id))
        i++
      load_subjects()

bind_exam_klass_section_change = ->
  $('.selectable_exam_klass').change ->
      load_sections()

  $('.selectable_exam_section').change ->
    load_subjects()

(($) ->
  window.ExamTimetable || (window.ExamTimetable = {})

  ExamTimetable.init = ->
    init_controls()

  init_controls = ->
    load_sections()
    bind_exam_klass_section_change()
).call(this)
