@animate_contact_box = ->
  $('.contact-box').each ->
    animationHover this, 'pulse'

@enable_ichecks = ->
  $('.i-checks').iCheck
    checkboxClass: 'icheckbox_square-green'
    radioClass: 'iradio_square-green'
