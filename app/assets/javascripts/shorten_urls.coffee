# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ClientSideValidations.formBuilders['SimpleForm::FormBuilder'].wrappers.default =
  add: (element, settings, message) ->
    wrapperElement = element.closest("#{settings.wrapper_tag}.#{settings.wrapper_class.replace(/\ /g, '.')}")
    errorElement   = wrapperElement.find("#{settings.error_tag}.invalid-feedback")

    unless errorElement.length
      errorElement = $("<#{settings.error_tag}/>", { class: 'invalid-feedback', text: message })
      wrapperElement.append errorElement

    wrapperElement.addClass settings.wrapper_error_class
    element.addClass 'is-invalid'

    errorElement.text message

  remove: (element, settings) ->
    wrapperElement = element.closest("#{settings.wrapper_tag}.#{settings.wrapper_class.replace(/\ /g, '.')}.#{settings.wrapper_error_class}")
    errorElement   = wrapperElement.find("#{settings.error_tag}.invalid-feedback")

    wrapperElement.removeClass settings.wrapper_error_class
    element.removeClass 'is-invalid'

    errorElement.remove()
