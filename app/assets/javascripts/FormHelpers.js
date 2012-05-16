jQuery.fn.bindToCleanErrorStyles = function() {
	$(this).find('.control-group.error').on({focus: function(event) {
  //when focusing an input, remove any error formatting
		$(event.delegateTarget).removeClass('error');
	}, change: function(event) {
		//when modifiying value of an input, remove the helper text
		$(event.delegateTarget).find('span.help-inline').remove();
	}}, 'input');
}