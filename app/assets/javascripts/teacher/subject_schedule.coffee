bind_select2 = ->
  $( ".select2_dropdown" ).select2
    theme: "bootstrap"
    width: '100%'

load_subjects = ->
    klass_id = $('#subject_schedule_klass_id :selected').val()
    section_id = $('#subject_schedule_section_id :selected').val()
    if section_id.blank?
      return $('#subject_schedule_subject_id').empty()

    $.ajax "/sections/#{section_id}/update_subjects",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        $('#subject_schedule_subject_id').empty()
      success: (data, textStatus, jqXHR) ->
        $('#subject_schedule_subject_id').empty()
        i = 0
        while i < data.length
          $('#subject_schedule_subject_id').append(new Option(data[i].name, data[i].id))
          i++

bind_class_change = ->
  $('#subject_schedule_klass_id').change ->
    klass_id = $('#subject_schedule_klass_id :selected').val()
    if klass_id.blank?
      $('#subject_schedule_section_id').empty()
      return $('#subject_schedule_subject_id').empty()

    $.ajax "/sections/update_sections?klass_id=#{klass_id}",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        $('#subject_schedule_section_id').empty()
        $('#subject_schedule_subject_id').empty()
      success: (data, textStatus, jqXHR) ->
        $('#subject_schedule_section_id').empty()
        $('#subject_schedule_subject_id').empty()
        i = 0
        while i < data.length
          $('#subject_schedule_section_id').append(new Option(data[i].name, data[i].id))
          i++
        load_subjects()

bind_section_change = ->
  $('#subject_schedule_section_id').change ->
    load_subjects()

(($) ->
  window.SubjectSchedule || (window.SubjectSchedule = {})

  SubjectSchedule.init = ->
    init_controls()

  init_controls = ->
    bind_select2()
    bind_class_change()
    bind_section_change()
).call(this)
