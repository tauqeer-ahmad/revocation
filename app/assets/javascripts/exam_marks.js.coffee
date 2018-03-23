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
    specific = $('.selectable_section').data('specific')
    params = "klass_id=#{klass_id}&section_id=#{section_id}"
    if specific
      params = "klass_id=#{klass_id}&section_id=#{section_id}&specific=#{specific}"

    $.ajax "/utilities/update_subjects?#{params}",
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

    $.ajax "/utilities/update_exams?klass_id=#{klass_id}&section_id=#{section_id}",
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

  load_sections = (klass_id = 0, section_selector = 0) ->
    section_selector = $('.selectable_section') unless section_selector.length
    klass_id = $('.selectable_klass :selected').val() unless klass_id.length
    return false unless klass_id

    section_selector.empty()
    $('.selectable_subject').empty()
    $('.selectable_exam').empty()
    specific = section_selector.data('specific')
    params = "klass_id=#{klass_id}"
    if specific
      params = "klass_id=#{klass_id}&specific=#{specific}"

    $.ajax "/utilities/update_sections?#{params}",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        section_selector.empty()
        $('.selectable_subject').empty()
        $('.selectable_exam').empty()
        i = 0

        while i < data.length
          section_selector.append(new Option(data[i].name, data[i].id))
          i++
        selected = section_selector.data('selected')
        if selected
          section_selector.children().find("[value=#{selected}]").prop('selected', true);
          # $(".selectable_section > [value=#{selected}]").prop('selected', true);
        load_subjects()
        load_exams()

  load_sections()

  $('.selectable_klass').change ->
    klass_id = $(this).val()
    section_selector = $(this).closest('.row').children().find('.selectable_section')

    load_sections(klass_id, section_selector) if klass_id.length

  $('.selectable_section').change ->
    load_subjects()
    load_exams()
  helight_selected_data_row()
