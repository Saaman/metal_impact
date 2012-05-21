$(document).ready(function() {

	//dynamic validation : email & confirmation should match
	$('#new-registration-modal').on('change', '#user_email_confirmation', function(event) {
	  if($(this).val() != $('#user_email').val()) {
	  	$(this).displayDynamicError('activerecord.errors.models.user.attributes.email_confirmation.custom_confirmation');
	  }
	})

	//assign default form behavior
	.bindToCleanErrorStyles();
});