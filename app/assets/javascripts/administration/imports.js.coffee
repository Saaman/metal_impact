$(document).ready ->
	# display / hide behavior for source_type change in the header
	$('a#change_source_type').on 'click', () ->
		$('div#source_type_form').show()
		$('div#source_type_block').hide()
	$('a#cancel_change_source_type').on 'click', () ->
		$('div#source_type_form').hide()
		$('div#source_type_block').show()

	# display entry when clicking on a failure
	$('div#failures-management').on 'click', 'tr', (e) ->
		entry_id = $(e.currentTarget).children('td.entry-id')[0].innerText
		url = '/administration/import_entries/'.concat(entry_id, '/edit')
		$('div#failures-management').load url
