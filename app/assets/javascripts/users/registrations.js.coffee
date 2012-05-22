$(document).ready ->
	
	$('#new-registration-modal')
	
	#dynamic validation : email & confirmation should match
	.on 'change', '#user_email_confirmation', (event) ->
	  if $(this).val() != $('#user_email').val()
	  	$(this).displayDynamicError(I18n.t('activerecord.errors.models.user.attributes.email_confirmation.custom_confirmation'))
	  else
	  	$(this).displayDynamicValidation()

	#dynamic validation : email should be a valid mail address
	.on 'change', '#user_email', (event) ->
		valid_email_regex = /// ^
		[\w+\-.]+
		@[a-z\d\-.]+
		\.[a-z]+
		$ ///i
		if not valid_email_regex.test $(this).val()
	  	$(this).displayDynamicError I18n.t('activerecord.errors.models.user.attributes.email.invalid')
	  else
	  	$(this).displayDynamicValidation()

	#dynamic validation : password should be 6 chars length, one special
	.on 'change', '#user_password', (event) ->
	  if $(this).val().length < 7
	  	return $(this).displayDynamicError I18n.t('activerecord.errors.models.user.attributes.password.too_short')
	  valid_password_regex = /// ^
	  [\w+\-.]*
	  [^a-zA-Z]+
	  [\w+\-.]*
	  $ ///i
	  if not valid_password_regex.test $(this).val()
	  	return $(this).displayDynamicError I18n.t('activerecord.errors.models.user.attributes.password.invalid')

	  $(this).displayDynamicValidation()

	#dynamic validation : pseudo should be unique
	.on 'change', '#user_pseudo', (event) ->
		$.getJSON 'users/is-pseudo-taken.json', { pseudo: $(this).val() }, (json) =>
			if json.isPseudoTaken
				$(this).displayDynamicError json.errorMessage
			else
				$(this).displayDynamicValidation()

	#assign default form behavior
	.bindToCleanErrorStyles()