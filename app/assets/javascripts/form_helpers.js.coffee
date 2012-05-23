jQuery.fn.bindToCleanErrorStyles = ->
	#when focusing an input in error, remove any error formatting + inline help
	$(this).on 'blur', '.control-group.error input', (event) ->
		$(this).parents('.control-group').removeClass('error').end().siblings('span.help-inline').remove()
	#when changing an input in success, remove any error formatting + inline help
	.on 'change', '.control-group.success input', (event) ->
		$(this).parents('.control-group').removeClass('success').end()

jQuery.fn.displayDynamicError = (message) ->
	$(this).after('<span class="help-inline">' + message + '</span>').parents('.control-group').addClass('error')

jQuery.fn.displayDynamicValidation = ->
	$(this).parents('.control-group').addClass('success')