$(document).ready ->
	#init datepickers
	$('input.date_picker').datepicker {
		format: I18n.t("time.formats.js_date")
		language: I18n.currentLocale()
		autoclose: true
	}

	#add icon search in typeahead fields
	$('input[name$="typeahead"]').wrap('<div class="input-append">')
	.parent().append('<span class="add-on"><i class="icon-search"></i></span>')

	#activate ajaxed links to modals
	$('.modal-trigger').on 'ajax:success', (event, xhr, status) ->
	  $('#modal-container').modal()
	.on 'ajax:error', (event, xhr, status) ->
		$('#modal-container').html xhr.responseText
		$('#modal-container').modal()
		alert 'error happened'