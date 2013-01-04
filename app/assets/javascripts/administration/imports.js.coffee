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

	#display failures list when clicking on "back to list" button on entry edit block
	$('div#failures-management').on 'click', 'a#back-to-failures', () ->
		url = '/administration/imports/'.concat($('input#entry_import_source_file_id').val(), '/failures')
		$('div#failures-management').load url
