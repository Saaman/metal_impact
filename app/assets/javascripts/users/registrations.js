$(document).ready(function() {

	
	$('#new-registration-modal')
	
	//dynamic validation : email & confirmation should match
	.on('change', '#user_email_confirmation', function(event) {
	  if($(this).val() != $('#user_email').val()) {
	  	$(this).displayDynamicError(I18n.t('activerecord.errors.models.user.attributes.email_confirmation.custom_confirmation'));
	  }
	  else {
	  	$(this).displayDynamicValidation();	
	  }
	})

	//dynamic validation : email should be a valid mail address
	.on('change', '#user_email', function(event) {
		var valid_email_regex = /^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$/i
		if(valid_email_regex.test($(this).val()) == false) {
	  	$(this).displayDynamicError(I18n.t('activerecord.errors.models.user.attributes.email.invalid'));
	  }
	  else {
	  	$(this).displayDynamicValidation();	
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
	  $(this).displayDynamicValidation();	
	})

	//dynamic validation : pseudo should be unique
	.on('change', '#user_pseudo', function(event) {
		$.getJSON('users/is-pseudo-taken.json', { pseudo: $(this).val() }, function(json) {
			if(json.isPseudoTaken) {
				$('#user_pseudo').displayDynamicError(json.errorMessage);
			}
			else {
				$('#user_pseudo').displayDynamicValidation();
			}
		});
	})

	//assign default form behavior
	.bindToCleanErrorStyles();
});