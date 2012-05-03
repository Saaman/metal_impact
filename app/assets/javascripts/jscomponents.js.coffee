$(document).ready ->	
	$('input.date_picker').datepicker({format: I18n.t("client.date.default_format"), language: I18n.currentLocale(), autoclose: true})