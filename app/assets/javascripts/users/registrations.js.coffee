#declare ajaxed pseudo-is-taken validation
CheckIfPseudoTaken = (elem) ->
	return if !elem.val()
	$.getJSON 'users/is-pseudo-taken.json', { pseudo: elem.val() }, (json) ->
		if json.isPseudoTaken
			elem.displayDynamicError I18n.t 'activerecord.errors.models.user.attributes.pseudo.taken'
		else
			elem.displayDynamicSuccess()

$ ->
	# Display an alert in case the pseudo already exists in database
	#Don't use valid state for ajax controls as it's impossible to force validation to happen
	#The display will look like webshims Html5 validations, except the validityState is not up to date!
	#Have in mind this won't prevent the form from being submitted
	$('div#modal-container').on 'changedvalid', '#user_pseudo', (e) ->
		CheckIfPseudoTaken $(e.target)
	
	$('div#modal-container').on 'focusout', '#user_pseudo', (e) ->
		return if !$(e.target).prop('validity').valid #do not perform ajax checks on focusout until field is valid
		CheckIfPseudoTaken $(e.target)



	# make sure the pseudo is at least 4 characters long
	$.webshims.addCustomValidityRule 'pseudoTooShort', (elem, value) ->
		return if !(value and $(elem).hasClass('pseudo-length'))
		return 4 > value.length
	, I18n.t 'activerecord.errors.models.user.attributes.pseudo.too_short'