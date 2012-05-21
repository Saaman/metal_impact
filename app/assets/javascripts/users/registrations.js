$(document).ready(function() {

	//dynamic validation : email & confirmation should match
	$('#new-registration-modal').on('change', '#user_email_confirmation', function(event) {
	  if($(this).val() != $('#user_email').val()) {
	  	$(this).displayDynamicError('activerecord.errors.models.user.attributes.email_confirmation.custom_confirmation');
	  }
	})

	//dynamic validation : password should be 6 chars length, one special
	.on('change', '#user_password', function(event) {
	  if($(this).val().length < 7) {
	  	$(this).displayDynamicError(I18n.t('activerecord.errors.models.user.attributes.password.too_short'));
	  	return;
	  }
	  var valid_password_regex = /^[\w+\-.]*[^a-zA-Z]+[\w+\-.]*$/i
	  if(valid_password_regex.test($(this).val()) == false) {
	  	$(this).displayDynamicError(I18n.t('activerecord.errors.models.user.attributes.password.invalid'));
	  	return;	
	  }
	})

	//dynamic validation : pseudo should be unique
	.on('change', '#user_pseudo', function(event) {
		$.getJSON('users/is-pseudo-taken.json', { pseudo: $(this).val() }, function(json) {
			if(json.isPseudoTaken) {
				$('#user_pseudo').displayDynamicError(json.errorMessage);
			}
		});
	})

	//assign default form behavior
	.bindToCleanErrorStyles();
});