bind_add_row_bulk_insert = ->
  $('#add-row-btn').on 'click', ->
    form_row = $('#bulk-form #form-fields .whole-form').last().clone().appendTo('#bulk-form #form-fields')
    form_row.find('input').val('')
    form_row.find('select').prop('disabled', false)
    form_row.find('button').prop('disabled', false)
    form_row.find('.guardian-form').find('input').prop('disabled', true)
    form_row.find('.guardian-form').addClass('hide')
    form_row.find('.select2').remove()
    Select2Trigger.init()

bind_delete_row_bulk_insert = ->
  $('body').on 'click', '.delete-row-btn', ->
    $('#form-fields .whole-form').length
    if $('#form-fields .whole-form').length == 1
      toastr.error('You cannot remove this!', 'Wake Up!')
    else
      $(this).parents('.whole-form').remove()

bind_guardian_form = ->
  $('body').on 'click', '.show-guardian-form-btn', ->
    $(this).prop('disabled', true)

    form = $(this).parents('.whole-form')
    guardian_form = form.find('.guardian-form')
    guardian_form.removeClass('hide')
    guardian_form.find('input').prop('disabled', false)
    form.find('.select-guardians').prop('disabled', true)

(($) ->
  window.Student || (window.Student = {})

  Student.init = ->
    init_controls()

  init_controls = ->
    bind_add_row_bulk_insert()
    bind_delete_row_bulk_insert()
    bind_guardian_form()
).call(this)
