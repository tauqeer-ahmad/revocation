bind_select2 = ->
  $( ".select2_dropdown" ).select2
    theme: "bootstrap"
    width: '100%'

load_subjects = ->
    klass_id = $('#question_paper_klass_id :selected').val()
    section_id = $('#question_paper_section_id :selected').val()
    if section_id.blank?
      return $('#question_paper_subject_id').empty()

    $.ajax "/sections/#{section_id}/update_subjects",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        $('#question_paper_subject_id').empty()
      success: (data, textStatus, jqXHR) ->
        $('#question_paper_subject_id').empty()
        i = 0
        while i < data.length
          $('#question_paper_subject_id').append(new Option(data[i].name, data[i].id))
          i++

bind_class_change = ->
  $('#question_paper_klass_id').change ->
    klass_id = $('#question_paper_klass_id :selected').val()
    if klass_id.blank?
      $('#question_paper_section_id').empty()
      return $('#question_paper_subject_id').empty()

    $.ajax "/sections/update_sections?klass_id=#{klass_id}",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        $('#question_paper_section_id').empty()
        $('#question_paper_subject_id').empty()
      success: (data, textStatus, jqXHR) ->
        $('#question_paper_section_id').empty()
        $('#question_paper_subject_id').empty()
        i = 0
        while i < data.length
          $('#question_paper_section_id').append(new Option(data[i].name, data[i].id))
          i++
        load_subjects()

bind_section_change = ->
  $('#question_paper_section_id').change ->
    load_subjects()

(($) ->
  window.QuestionPaper || (window.QuestionPaper = {})

  QuestionPaper.init = ->
    init_controls()

  init_controls = ->
    bind_select2()
    bind_class_change()
    bind_section_change()
).call(this)
