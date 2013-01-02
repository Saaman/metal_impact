$(document).ready ->
	$('a#change_source_type').on 'click', () ->
		$('div#source_type_form').show()
		$('div#source_type_block').hide()
	$('a#cancel_change_source_type').on 'click', () ->
		$('div#source_type_form').hide()
		$('div#source_type_block').show()