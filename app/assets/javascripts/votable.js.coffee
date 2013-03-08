$(document).ready ->
	vote_forms = $("form[id^='form-vote']")
	vote_forms.on 'ajax:success', (evt, data, status, xhr) ->
		vote_forms.children('button').removeClass 'voted'
		$(this).children('button').addClass 'voted'

		$('form#form-vote-up button span').text data.votes_up
		$('form#form-vote-down button span').text data.votes_down
		$('div#votes-display > span').text(data.votes_ratio + '%')