jQuery ->

  helight_selected_data_row = ->
    $('body').on 'click', '.selected-data-row', ->
      $('.selectable-row').removeClass('table-helighted-row')
      row_id = $(this).attr("marker")
      $("#row-#{row_id}").addClass('table-helighted-row')

  load_subjects = ->
    klass_id = $('.selectable_klass :selected').val()
    section_id = $('.selectable_section :selected').val()
    return false unless section_id
    $('.selectable_subject').empty()

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
        selected = $('.selectable_subject').data('selected')
        if selected
          $(".selectable_subject > [value=#{selected}]").prop('selected', true);

  load_exams = ->
    klass_id = $('.selectable_klass :selected').val()
    section_id = $('.selectable_section :selected').val()
    return false unless section_id
    $('.selectable_exam').empty()

    $.ajax "/administrator/classes/#{klass_id}/sections/#{section_id}/update_exams",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        $('.selectable_exam').empty()
        i = 0
        while i < data.length
          $('.selectable_exam').append(new Option(data[i].name, data[i].id))
          i++
        selected = $('.selectable_exam').data('selected')
        if selected
          $(".selectable_exam > [value=#{selected}]").prop('selected', true);

  load_sections = ->
    klass_id = $('.selectable_klass :selected').val()
    return false unless klass_id
    $('.selectable_section').empty()
    $('.selectable_subject').empty()
    $('.selectable_exam').empty()

    $.ajax "/administrator/classes/#{klass_id}/update_sections",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        $('.selectable_section').empty()
        $('.selectable_subject').empty()
        $('.selectable_exam').empty()
        i = 0
        while i < data.length
          $('.selectable_section').append(new Option(data[i].name, data[i].id))
          i++
        selected = $('.selectable_section').data('selected')
        if selected
          $(".selectable_section > [value=#{selected}]").prop('selected', true);
        load_subjects()
        load_exams()

  load_sections()
  $('.selectable_klass').change ->
    load_sections()

  $('.selectable_section').change ->
    load_subjects()
    load_exams()
  helight_selected_data_row()
