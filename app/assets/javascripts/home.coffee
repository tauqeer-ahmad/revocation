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
                else
                  window.location = current_url.replace(last_index, '')
              else
                window.location = current_url
          )
      else
        swal 'Cancelled', "#{$(this).data('object')} is safe!", 'error'

$ ->
  bind_destroy_alert()
