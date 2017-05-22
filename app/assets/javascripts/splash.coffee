init_setup = ->
  $('body').addClass 'landing-page'
  $('body').attr 'id', 'page-top'
  $('body').scrollspy
    target: '.navbar-fixed-top'
    offset: 80

  $('a.page-scroll').bind 'click', (event) ->
    link = $(this)
    $('html, body').stop().animate { scrollTop: $(link.attr('href')).offset().top - 50 }, 500
    event.preventDefault()

  cbpAnimatedHeader = do ->
    docElem = document.documentElement
    header = document.querySelector('.navbar-default')
    didScroll = false
    changeHeaderOn = 200

    init = ->
      window.addEventListener 'scroll', ((event) ->
        if !didScroll
          didScroll = true
          setTimeout scrollPage, 250
      ), false

    scrollPage = ->
      sy = scrollY()
      if sy >= changeHeaderOn
        $(header).addClass 'navbar-scroll'
      else
        $(header).removeClass 'navbar-scroll'
      didScroll = false

    scrollY = ->
      window.pageYOffset or docElem.scrollTop

    init()

(($) ->
  window.Splash || (window.Splash = {})

  Splash.init = ->
    init_controls()

  init_controls = ->
    init_setup()
).call(this)
