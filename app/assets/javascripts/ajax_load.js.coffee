$(document).ready ->
	$("img.ajax-load").hide()
	$("img.ajax-success").hide()
	$("img.ajax-fail").hide()
	$('select.submittable').live "change", () ->
		$("img.ajax-success").hide();
		$("img.ajax-fail").hide();
		$(this).siblings("div.ajax-result").children("img.ajax-load").show()
		$(this).parents('form:first').submit()