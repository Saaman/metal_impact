jQuery.fn.bindToCleanErrorStyles = ->
	$(this).on 'focus', '.control-group.error input, .control-group.success input', (event) ->
  #when focusing an input, remove any error formatting + inline help
		$(this).parents('.control-group').removeClass('error').removeClass('success').end().siblings('span.help-inline').remove()

jQuery.fn.displayDynamicError = (message) ->
	$(this).after('<span class="help-inline">' + message + '</span>').parents('.control-group').addClass('error')

jQuery.fn.displayDynamicValidation = ->
	$(this).parents('.control-group').addClass('success')