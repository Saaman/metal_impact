$(document).ready ->

	setBehaviors()

	#reload show page every 10 seconds
	setInterval () ->
		if $('input#source_file_auto_refresh').val()
			$('div.contentzone').load '/administration/imports/'.concat($('input#source_file_id').val(), '.js'), () ->
				setBehaviors()
	, 10000

setBehaviors = () ->
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
			url = '/administration/imports/'.concat($('input#source_file_id').val(), '/failures')
			$('div#failures-management').load url

		#manage the display of entries counts per target_model
		$('div#entries-counts-details').hide()

		$('span#toggle-details').tooltip().on {
			click: () ->
				$('div#entries-counts-details').toggle 'fast'
		, mouseenter: () ->
				$(this).addClass 'as-clickable'
		, mouseleave: () ->
				$(this).removeClass 'as-clickable'
		}