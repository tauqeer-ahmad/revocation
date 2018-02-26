bind_class_change = ->
  $('#notice_klass_id').change ->
    klass_id = $('#notice_klass_id :selected').val()
    if klass_id.blank?
      $('#notice_section_id').empty()
      return $('#notice_subject_id').empty()


    $.ajax "/utilities/update_sections?klass_id=#{klass_id}",
      type: 'GET'
      dataType: 'json'
      data: []
      error: (jqXHR, textStatus, errorThrown) ->
        $('#notice_section_id').empty()
      success: (data, textStatus, jqXHR) ->
        $('#notice_section_id').empty()
        $('#notice_section_id').append(new Option(data[x].name, data[x].id)) for x in [0..(data.length)]

enable_class = ->
  $('.class-specific').removeClass('hide')
  $('.class-specific select').prop('disabled', false)

disable_class = ->
  $('.class-specific').addClass('hide')
  $('.class-specific select').prop('disabled', true)

enable_section = ->
  $('.section-specific').removeClass('hide')
  $('.section-specific select').prop('disabled', false)

disable_section = ->
  $('.section-specific').addClass('hide')
  $('.section-specific select').prop('disabled', true)

bind_type_change = ->
  $('.notice-type').change ->
    if $(this).val() == 'Class Specific'
      enable_class()
      disable_section()
    else if $(this).val() == 'Section Specific'
      enable_class()
      enable_section()
    else
      disable_class()
      disable_section()

(($) ->
  window.Notice || (window.Notice = {})

  Notice.init = ->
    init_controls()

  init_controls = ->
    bind_class_change()
    bind_type_change()
).call(this)
