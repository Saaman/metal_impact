$(document).ready ->
	#init datepickers
	$('input.date_picker').datepicker {
		format: I18n.t("time.formats.js_date")
		language: I18n.currentLocale()
		autoclose: true
	}

	#add icon search in typeahead fields
	$('input[name$="typeahead"]').wrap('<div class="input-prepend">')
	.parent().prepend('<span class="add-on"><i class="icon-search"></i></span>')

	#add remove button on fields with class 'removable'
	$('input.removable').wrap('<div class="input-append">')
	.parent().append('<button class="btn" type="button"><i class="icon-remove"></i></button>')


	$('div.modal').on 'hidden', () ->
		$(this).empty()

	$('body').on 'change', 'select.sorting_select', ->
		$.get $(this).attr('reload-url'), { sort_order: $(this).val() }, (data) ->
			$('div.contentzone').html(data)

	#remove the top alert about javascript requirement
	$('div#js-alert').remove()

	#Ajax errors treatment
	$(document).on 'ajax:error', (event, jqXHR, ajaxSettings, thrownError) ->
		if jqXHR.status == 401 #unauthorized
			$('div#flashes').html jqXHR.responseText
