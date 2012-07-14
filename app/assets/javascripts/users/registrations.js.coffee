$(document).ready ->
	
	$('#modal-container')
	
	#dynamic validation : pseudo should be unique
	.addValidation '#new_user_registration #user_pseudo', (elem) ->
		if $(elem).val().length < 4
				return I18n.t('activerecord.errors.models.user.attributes.pseudo.too_short')
		$.getJSON 'users/is-pseudo-taken.json', { pseudo: $(elem).val() }, (json) =>
			if json.isPseudoTaken
				$(elem).displayDynamicError(json.errorMessage)
		return ''