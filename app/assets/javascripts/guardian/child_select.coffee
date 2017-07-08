bind_child_selection = ->
  $('.select-children').on 'click', ->
    value = $(this).data('child-name')
    child_id = $(this).data('child-id')

    swal {
      title: 'Are you sure?'
      text: "You want to switch to #{value}."
      type: 'warning'
      showCancelButton: true
      confirmButtonColor: '#5bba4b'
      confirmButtonText: 'Switch'
      closeOnConfirm: true
    }, (isConfirm) ->
      if isConfirm
        path = "/select_student?selected_student=#{child_id}"
        options =
          url: path
          type: 'Post'
          success: (data) ->
            window.location.reload()
          error: ->
            toastr.error("Invalid params for child selection.")

        $.ajax options

(($) ->
  window.ChildSelect || (window.ChildSelect = {})

  ChildSelect.init = ->
    init_controls()

  init_controls = ->
    bind_child_selection()
).call(this)
