jQuery.fn.bindToCleanErrorStyles = function() {
	$(this).on('focus', '.control-group.error input', function(event) {
  //when focusing an input, remove any error formatting + inline help
		$(this).parents('.control-group').removeClass('error').end().siblings('span.help-inline').remove();
	})
}

jQuery.fn.displayDynamicError = function(message) {
	$(this).after('<span class="help-inline">' + message + '</span>').parents('.control-group').addClass('error');
}