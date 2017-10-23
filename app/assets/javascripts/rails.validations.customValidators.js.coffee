window.ClientSideValidations.validators.local['in_future'] = (element, options) ->
  form = element.parents('form')
  target = form.find("*[name='#{options['name']}']")
  return false if target.val() == ""
  end_date = new Date(element.val())
  start_date = new Date(target.val())
  if options['comparison'] == 'gte' && end_date <= start_date
    options.message
  else if options['comparison'] == 'lte' && end_date >= start_date
    options.message
  else if options['comparison'] == 'equal' && end_date == start_date
    options.message
  else
    if element.data('valid') != false
      target.data('changed', true).isValid(form[0].ClientSideValidations.settings.validators)
