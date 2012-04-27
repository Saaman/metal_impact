$(document).ready ->
	$(".ajax-load").hide()
	$(".ajax-success").hide()
	$(".ajax-fail").hide()
	$('.submittable').live "change", () ->
		$(".ajax-success").hide();
		$(".ajax-fail").hide();
		$(this).siblings(".ajax-result").children(".ajax-load").show()
		$(this).parents('form:first').submit()