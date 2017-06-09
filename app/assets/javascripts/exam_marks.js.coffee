jQuery ->

  helight_selected_data_row = ->
    $('body').on 'click', '.selected-data-row', ->
      $('.selectable-row').removeClass('table-helighted-row')
      row_id = $(this).attr("marker")
      $("#row-#{row_id}").addClass('table-helighted-row')

  load_subjects = ->
    klass_id = $('.selectable_klass :selected').val()
    section_id = $('.selectable_section :selected').val()
    unless section_id
      return $('.selectable_subject').empty()

    $.ajax "/administrator/classes/#{klass_id}/sections/#{section_id}/update_subjects",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        $('.selectable_subject').empty()
        i = 0
        while i < data.length
          $('.selectable_subject').append(new Option(data[i].name, data[i].id))
          i++

  load_sections = ->
    klass_id = $('.selectable_klass :selected').val()
    unless klass_id
      $('.selectable_section').empty()
      return $('.selectable_subject').empty()

    $.ajax "/administrator/classes/#{klass_id}/update_sections",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        $('.selectable_section').empty()
        $('.selectable_subject').empty()
        i = 0
        while i < data.length
          $('.selectable_section').append(new Option(data[i].name, data[i].id))
          i++
        load_subjects()

  load_sections()
  $('.selectable_klass').change ->
    load_sections()

  $('.selectable_section').change ->
    load_subjects()
  helight_selected_data_row()
