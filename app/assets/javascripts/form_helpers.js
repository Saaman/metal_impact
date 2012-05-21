jQuery.fn.bindToCleanErrorStyles = function() {
	$(this).on('focus', '.control-group.error input, .control-group.success input', function(event) {
  //when focusing an input, remove any error formatting + inline help
		$(this).parents('.control-group').removeClass('error').removeClass('success').end().siblings('span.help-inline').remove();
	})
}

jQuery.fn.displayDynamicError = function(message) {
	$(this).after('<span class="help-inline">' + message + '</span>').parents('.control-group').addClass('error');
}

jQuery.fn.displayDynamicValidation = function() {
	$(this).parents('.control-group').addClass('success');
}