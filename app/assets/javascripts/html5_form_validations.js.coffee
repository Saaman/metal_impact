$ ->
	$.webshims.setOptions {
		'basePath': '/assets/webshims/minified/shims/',
		'forms': {overrideMessages: true} }
	$.webshims.activeLang I18n.currentLocale()

	"use strict"
	#load ES5 and HTML5 form features, if not implemented
	$.webshims.polyfill 'es5 forms'

	$('body').on {
		'changedvalid': (e) ->
			$(e.target).displayDynamicSuccess()
		'changedinvalid': (e) ->
			$(e.target).displayDynamicError()
		# 'invalid': (e) ->
		# 	#prevent browser from showing native validation message
		# 	e.preventDefault()
		'change': (e) ->
			if $(e.target) isnt ':valid'
				$(e.target).displayDynamicError()
		'firstinvalid': (e) ->
			return false
		}, 'form'

jQuery.fn.displayDynamicError = (message) ->
	$(this).siblings('span.help-inline').remove().end()
	.after('<span class="help-inline">' + (message ? $(this).prop('customValidationMessage')) + '</span>').parents('.control-group').addClass('error').removeClass("success")

jQuery.fn.displayDynamicSuccess = () ->
	$(this).siblings('span.help-inline').remove().end()
	.parents('.control-group').addClass('success').removeClass("error")

jQuery.fn.addValidation = (selector, validationFn) ->
	$(this).on 'focusout', selector, (event) ->
		this.setCustomValidity ""
		return if not $(this).is ':valid'
		this.setCustomValidity(validationFn(this))
		return $(this)