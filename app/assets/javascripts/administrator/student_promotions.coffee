load_promotion_sections = ->
  klass_id = $('.selectable_promotion_klass :selected').val()
  return unless klass_id
  $('.selectable_promotion_section').empty()

  specific = $('.selectable_section').data('specific')
  params = "klass_id=#{klass_id}&initialized=true"
  if specific
    params = "klass_id=#{klass_id}&initialized=true&specific=#{specific}"

  $.ajax "/utilities/update_sections?#{params}",
    type: 'GET'
    dataType: 'json'
    data: []
    error: (jqXHR, textStatus, errorThrown) ->
      console.log("AJAX Error: #{textStatus}")
    success: (data, textStatus, jqXHR) ->
      $('.selectable_promotion_section').empty()
      i = 0
      while i < data.length
        $('.selectable_promotion_section').append(new Option(data[i].name, data[i].id))
        i++

auto_load_promotable_students = ->
  klass = $('.selectable_klass :selected').val()
  section = $('.selectable_section :selected').val()
  promotion_klass = $('.selectable_promotion_klass :selected').val()
  promotion_section = $('.selectable_promotion_section :selected').val()

  if klass && section && promotion_klass && promotion_section
    $('#manage_promotion_button').click()

bind_sweet_alert_for_enrollment =->
  $('body').on 'click', "[data-behavior='promotion']", (e) ->
    e.preventDefault()
    form = $(this).parents('form');
    swal {
      title: 'Are you sure?'
      text: "Please procceed if you are sure about selected students."
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Yes, Proceed!'
      cancelButtonText: 'No, cancel!'
      closeOnConfirm: false
      closeOnCancel: false
    }, (confirmed) =>
      if confirmed
        if $('.promotion_checkbox:checked').length > 0
          form.submit();
        else
          swal 'Error', "Please select at least one student for promotion.", 'error'
      else
        swal 'Cancelled', "Promotion cancelled.", 'error'

bind_promotions_section_load =->
  $('.selectable_promotion_klass').change ->
    load_promotion_sections()

@enable_all_checked =->
  $('body').on 'ifChecked', '#select_all', ->
    $('.select_all_checkbox').iCheck 'check'
    return
  $('body').on 'ifUnchecked', '#select_all', ->
    $('.select_all_checkbox').iCheck 'uncheck'
    return

(($) ->
  window.StudentPromotion || (window.StudentPromotion = {})

  StudentPromotion.init = ->
    init_controls()

  init_controls = ->
    enable_ichecks()
    enable_all_checked()
    bind_sweet_alert_for_enrollment()
    load_promotion_sections()
    bind_promotions_section_load()
).call(this)
