$(document).ready ->
	vote_buttons = $("button[id^='vote-']")
	vote_buttons.parent('form').on 'ajax:success', (evt, data, status, xhr) ->
		vote_buttons.removeClass 'voted'
		$(this).find(vote_buttons).addClass 'voted'

		$('button#vote-up span').text data.votes_up
		$('button#vote-down span').text data.votes_down
		$('div#votes-display > span').text(data.votes_ratio + '%')