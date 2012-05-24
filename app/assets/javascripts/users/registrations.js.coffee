$(document).ready ->
	
	$('#new-registration-modal')
	
	#dynamic validation : email & confirmation should match
	.addValidation '#user_email_confirmation', (elem) ->
		if $(elem).val() isnt $('#user_email').val()
			return I18n.t('activerecord.errors.models.user.attributes.email_confirmation.custom_confirmation')
		return ''

	#dynamic validation : email should be a valid mail address
	.addValidation '#user_email', (elem) ->
		valid_email_regex = /// ^[\w+\-.]+@[a-z\d\-.]+\.[a-z]+$ ///i
		if not valid_email_regex.test $(elem).val()
			return I18n.t('activerecord.errors.models.user.attributes.email.invalid')
		return ''
	
	#dynamic validation : password should be 6 chars length, one special
	.addValidation '#user_password', (elem) ->
		valid_password_regex = /// ^[\w+\-.]*[^a-zA-Z]+[\w+\-.]*$ ///i
		if $(elem).val().length < 6
				return I18n.t('activerecord.errors.models.user.attributes.password.too_short')
		if not valid_password_regex.test $(elem).val()
			return I18n.t('activerecord.errors.models.user.attributes.password.invalid')
		return ''

	#dynamic validation : pseudo should be unique
	.addValidation '#user_pseudo', (elem) ->
		if $(elem).val().length < 4
				return I18n.t('activerecord.errors.models.user.attributes.pseudo.too_short')
		$.getJSON 'users/is-pseudo-taken.json', { pseudo: $(elem).val() }, (json) =>
			if json.isPseudoTaken
				$(elem).displayDynamicError(json.errorMessage)
		return ''