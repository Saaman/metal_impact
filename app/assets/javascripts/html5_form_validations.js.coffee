$ ->
	$.webshims.setOptions {
		'basePath': '/assets/webshims/minified/shims/',
		'waitReady': false,
		'forms': {customMessages: true} }
	$.webshims.activeLang I18n.currentLocale()

	"use strict"
	#load ES5 and HTML5 form features, if not implemented
	$.webshims.polyfill 'es5 forms'

	$('body').on {
		'changedvalid': (e) ->
			return if $(e.target).hasClass('skipval')
			$(e.target).displayDynamicSuccess()
		'changedinvalid': (e) ->
			return if $(e.target).hasClass('skipval')
			$(e.target).displayDynamicError()
		'change': (e) ->
			#this event handler allow to display the good error message in case the field is still invalid, but for a different reason
			return if $(e.target).hasClass('skipval')
			if !$(e.target).prop('validity').valid
				$(e.target).displayDynamicError()
		'firstinvalid': (e) ->
			return false
		}, 'form'

jQuery.fn.displayDynamicError = (message = "") ->
	errorMessage = message
	errorMessage = $(this).prop('customValidationMessage') if !errorMessage
	#in case customValidationMessage is empty, take the validationMessage. Probably a workaround to compensate webshims lacks about custom validators
	errorMessage = $(this).prop('validationMessage') if !errorMessage
	
	$(this).siblings('span.help-inline').remove().end()
	.after('<span class="help-inline">' + errorMessage + '</span>').parents('div.control-group').addClass('error').removeClass("success")

jQuery.fn.displayDynamicSuccess = () ->
	$(this).siblings('span.help-inline').remove().end()
	.parents('div.control-group').addClass('success').removeClass("error")