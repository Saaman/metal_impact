$.webshims.setOptions 'basePath', '/assets/webshims/minified/shims/'

"use strict"
#load ES5 and HTML5 form features, if not implemented
$.webshims.polyfill 'es5 forms'

$(document).ready ->
	#objectCreate behaves similiar to Object.create
	window.validationUI = $.webshims.objectCreate {
		init: ->
			$(document)
			.on {
				'focusout': (e) ->
					if (not $(e.target).prop('willValidate')) or $(e.target).prop('type') == 'submit'
						return
					if $(e.target).is(':valid')
						$(e.target).displayDynamicSuccess()
					else
						$(e.target).displayDynamicError()
				###
				invalid is a simple, non-bubbling event: 
				webshims lib sets the useCapture argument in addEventListener to true, 
				so that the event is also fired on parent elements
				###
				'invalid': (e) ->
					$(e.target).displayDynamicError()
					#preventDefault to remove the native browser error UI
					e.preventDefault()
				#firstinvalid-event is a webshims extension and is triggered only on the first invalid element
				'firstinvalid': (e) ->
					#$.webshims.validityAlert is an helper object to create simple, styleable error messages
					$.webshims.validityAlert.showFor e.target
			}, 'input[validate-input!="false"]'
	}
	validationUI.init()

jQuery.fn.displayDynamicError = (message) ->
	$(this).siblings('span.help-inline').remove().end()
	.after('<span class="help-inline">' + (message ? $(this).prop('validationMessage')) + '</span>').parents('.control-group').addClass('error').removeClass("success")

jQuery.fn.displayDynamicSuccess = () ->
	$(this).siblings('span.help-inline').remove().end()
	.parents('.control-group').addClass('success').removeClass("error")

jQuery.fn.addValidation = (selector, validationFn) ->
	$(this).on 'focusout', selector, (event) ->
		this.setCustomValidity ""
		return if not $(this).is ':valid'
		this.setCustomValidity(validationFn(this))
		return $(this)