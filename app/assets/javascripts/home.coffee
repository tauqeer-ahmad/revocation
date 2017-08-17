bind_switch_term = ->
  $('#term-switch').on 'click', (e) ->
    swal {
      title: 'Are you sure?'
      text: "You want to switch to Active Term!"
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#1c84c6'
      confirmButtonText: 'Yes, switch'
      cancelButtonText: 'No, cancel!'
      closeOnConfirm: true
      closeOnCancel: true
    }, (confirmed) =>
      if confirmed
        $.ajax(
            url: "/administrator/terms/#{$(this).data('active-term')}/update_selected_term"
            method: 'Put'
            dataType: 'JSON'
            success: =>
              swal 'Updated!', "Context has switched to Active Term.", 'success'
              location.reload()
          )

@bind_destroy_alert = ->
  $('body').on 'click', "[data-behavior='delete'], [data-behavior='ajax-delete']", (e) ->
    e.preventDefault()

    ajax_delete = $(this).data('behavior') == 'ajax-delete'

    swal {
      title: 'Are you sure?'
      text: "You will not be able to recover this #{$(this).data('object')}!"
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#DD6B55'
      confirmButtonText: 'Yes, delete it!'
      cancelButtonText: 'No, cancel!'
      closeOnConfirm: false
      closeOnCancel: false
    }, (confirmed) =>
      if confirmed
        if ajax_delete
          $.ajax(
            url: $(this).attr('href')
            method: 'DELETE'
            success: =>
              swal 'Deleted!', "#{$(this).data('object')} has been deleted.", 'success'
          )
        else
          $.ajax(
            url: $(this).attr('href')
            dataType: 'JSON'
            method: 'DELETE'
            success: =>
              swal 'Deleted!', "#{$(this).data('object')} has been deleted.", 'success'
              current_url = window.location.href
              last_index = current_url.split('/').pop()
              if last_index.match(/\D+/) == null
                if current_url.indexOf('classes') > 0 && current_url.indexOf('sections') > 0
                  window.location = '/administrator/sections'
                else if current_url.indexOf('assignments') > 0
                  window.location = current_url
                else
                  window.location = current_url.replace(last_index, '')
              else
                window.location = current_url
          )
      else
        swal 'Cancelled', "#{$(this).data('object')} is safe!", 'error'

display_uploaded_image = ->
  $('#teacher_avatar, #student_avatar, #guardian_avatar, #institution_logo').on 'change', (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader

    reader.onload = (file) ->
      img = new Image
      img.src = file.target.result
      $('#uploaded-image').html img
      $('#uploaded-image img').addClass('img-thumbnail').css('width', '100%')

    reader.readAsDataURL image

    $('#previous-image').hide()

set_clipboard = ->
  clipboard = new Clipboard('.clipboard-btn')

  clipboard.on 'success', (e) ->
    toastr.success 'Copied!'

  clipboard.on 'error', (e) ->
    toastr.error 'Error while Copying!'

@bind_note_double_click_edit = ->
  $('body').on 'dblclick', '.note-container', ->
    note_id = $(this).data('id')
    $("#note-edit-#{note_id}").modal('show')

feedback_model_hide_trigger = ->
  $('#feedback-modal').on 'hidden.bs.modal', ->
    $('#feedback-model-trigger').on 'focus', ->
      $(this).blur()

bind_select2 = ->
  $('.select2_dropdown').select2
    theme: 'bootstrap'
    width: '100%'

$ ->
  bind_destroy_alert()
  display_uploaded_image()
  bind_switch_term()
  set_clipboard()
  bind_note_double_click_edit()
  feedback_model_hide_trigger()
  bind_select2()
