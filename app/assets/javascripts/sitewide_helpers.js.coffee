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


	$('div.modal').on 'hidden', () ->
		$(this).empty()

	$('body').on 'change', 'select.sorting_select', ->
		$.get $(this).attr('reload-url'), { sort_order: $(this).val() }, (data) ->
			$('div.contentzone').html(data)