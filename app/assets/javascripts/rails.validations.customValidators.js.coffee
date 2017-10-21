window.ClientSideValidations.validators.local['in_future'] = (element, options) ->
  form = element.parents('form')
  target = form.find("*[name='#{options['name']}']")
  return false if target.val() == ""
  end_date = new Date(element.val())
  start_date = new Date(target.val())
  if end_date <= start_date
    options.message
