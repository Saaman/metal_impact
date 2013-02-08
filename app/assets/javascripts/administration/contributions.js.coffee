$(document).ready ->

	# display contribution when clicking on a contribution line
	$('table#contributions-table').on 'click', 'tr', (e) ->
		contrib_id = $(e.currentTarget).attr('data-contribution-id')
		window.location.href = "/administration/contributions/#{contrib_id}"