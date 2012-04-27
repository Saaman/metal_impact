$(document).ready ->	
	$('input.date_picker').datepicker({format: I18n.t("date.formats.jsdefault"), language: I18n.currentLocale(), autoclose: true})