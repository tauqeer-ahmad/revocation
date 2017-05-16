init_config = ->
  $('#fixednavbar').click ->
    if $('#fixednavbar').is(':checked')
      $('.navbar-static-top').removeClass('navbar-static-top').addClass 'navbar-fixed-top'
      $('body').removeClass 'boxed-layout'
      $('body').addClass 'fixed-nav'
      $('#boxedlayout').prop 'checked', false
      if localStorageSupport
        localStorage.setItem 'boxedlayout', 'off'
      if localStorageSupport
        localStorage.setItem 'fixednavbar', 'on'
    else
      $('.navbar-fixed-top').removeClass('navbar-fixed-top').addClass 'navbar-static-top'
      $('body').removeClass 'fixed-nav'
      if localStorageSupport
        localStorage.setItem 'fixednavbar', 'off'
    return
  # Enable/disable fixed sidebar
  $('#fixedsidebar').click ->
    if $('#fixedsidebar').is(':checked')
      $('body').addClass 'fixed-sidebar'
      $('.sidebar-collapse').slimScroll
        height: '100%'
        railOpacity: 0.9
      if localStorageSupport
        localStorage.setItem 'fixedsidebar', 'on'
    else
      $('.sidebar-collapse').slimscroll destroy: true
      $('.sidebar-collapse').attr 'style', ''
      $('body').removeClass 'fixed-sidebar'
      if localStorageSupport
        localStorage.setItem 'fixedsidebar', 'off'
    return
  # Enable/disable collapse menu
  $('#collapsemenu').click ->
    if $('#collapsemenu').is(':checked')
      $('body').addClass 'mini-navbar'
      SmoothlyMenu()
      if localStorageSupport
        localStorage.setItem 'collapse_menu', 'on'
    else
      $('body').removeClass 'mini-navbar'
      SmoothlyMenu()
      if localStorageSupport
        localStorage.setItem 'collapse_menu', 'off'
    return
  # Enable/disable boxed layout
  $('#boxedlayout').click ->
    if $('#boxedlayout').is(':checked')
      $('body').addClass 'boxed-layout'
      $('#fixednavbar').prop 'checked', false
      $('.navbar-fixed-top').removeClass('navbar-fixed-top').addClass 'navbar-static-top'
      $('body').removeClass 'fixed-nav'
      $('.footer').removeClass 'fixed'
      $('#fixedfooter').prop 'checked', false
      if localStorageSupport
        localStorage.setItem 'fixednavbar', 'off'
      if localStorageSupport
        localStorage.setItem 'fixedfooter', 'off'
      if localStorageSupport
        localStorage.setItem 'boxedlayout', 'on'
    else
      $('body').removeClass 'boxed-layout'
      if localStorageSupport
        localStorage.setItem 'boxedlayout', 'off'
    return
  # Enable/disable fixed footer
  $('#fixedfooter').click ->
    if $('#fixedfooter').is(':checked')
      $('#boxedlayout').prop 'checked', false
      $('body').removeClass 'boxed-layout'
      $('.footer').addClass 'fixed'
      if localStorageSupport
        localStorage.setItem 'boxedlayout', 'off'
      if localStorageSupport
        localStorage.setItem 'fixedfooter', 'on'
    else
      $('.footer').removeClass 'fixed'
      if localStorageSupport
        localStorage.setItem 'fixedfooter', 'off'
    return
  # SKIN Select
  $('.spin-icon').click ->
    $('.theme-config-box').toggleClass 'show'
    return
  # Default skin
  $('.s-skin-0').click ->
    $('body').removeClass 'skin-1'
    $('body').removeClass 'skin-2'
    $('body').removeClass 'skin-3'
    return
  # Blue skin
  $('.s-skin-1').click ->
    $('body').removeClass 'skin-2'
    $('body').removeClass 'skin-3'
    $('body').addClass 'skin-1'
    return
  # Inspinia ultra skin
  $('.s-skin-2').click ->
    $('body').removeClass 'skin-1'
    $('body').removeClass 'skin-3'
    $('body').addClass 'skin-2'
    return
  # Yellow skin
  $('.s-skin-3').click ->
    $('body').removeClass 'skin-1'
    $('body').removeClass 'skin-2'
    $('body').addClass 'skin-3'
    return
  if localStorageSupport
    collapse = localStorage.getItem('collapse_menu')
    fixedsidebar = localStorage.getItem('fixedsidebar')
    fixednavbar = localStorage.getItem('fixednavbar')
    boxedlayout = localStorage.getItem('boxedlayout')
    fixedfooter = localStorage.getItem('fixedfooter')
    if collapse == 'on'
      $('#collapsemenu').prop 'checked', 'checked'
    if fixedsidebar == 'on'
      $('#fixedsidebar').prop 'checked', 'checked'
    if fixednavbar == 'on'
      $('#fixednavbar').prop 'checked', 'checked'
    if boxedlayout == 'on'
      $('#boxedlayout').prop 'checked', 'checked'
    if fixedfooter == 'on'
      $('#fixedfooter').prop 'checked', 'checked'

(($) ->
  window.ConfigBox || (window.ConfigBox = {})

  ConfigBox.init = ->
    init_controls()

  init_controls = ->
    init_config()
).call(this)
