jQuery ->

  helight_selected_data_row = ->
    console.log("asdadad")
    $('.selected-data-row').click ->
      console.log this
      $('.selectable-row').removeClass('table-helighted-row')
      row_id = $(this).attr("marker")
      console.log(row_id)
      $("#row-#{row_id}").addClass('table-helighted-row')

  load_subjects = ->
    klass_id = $('#klass_id :selected').val()
    section_id = $('#section_id :selected').val()
    if section_id.blank?
      return $('#subject_id').empty()
ß
    $.ajax "classes/#{klass_id}/sections/#{section_id}/update_subjects",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        $('#subject_id').empty()
        i = 0
        while i < data.length
          $('#subject_id').append(new Option(data[i].name, data[i].id))
          i++
  $('#klass_id').change ->
    klass_id = $('#klass_id :selected').val()
    if klass_id.blank?
      $('#section_id').empty()
      return $('#subject_id').empty()

    $.ajax "classes/#{klass_id}/update_sections",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        $('#section_id').empty()
        $('#subject_id').empty()
        i = 0
        while i < data.length
          $('#section_id').append(new Option(data[i].name, data[i].id))
          i++
        load_subjects()

  $('#section_id').change ->
    load_subjects()
  helight_selected_data_row()
