toggle_review_form = (show) ->
	$('form#add_review').toggle(!show)
	$('div#review-form').toggle(show)

$ ->
	$('form#add_review').on {
		'ajax:success': (event, data) ->
			$('div#review-form').html(data)
			toggle_review_form true
		}
	$('body').on 'click', 'div#review-form a#cancel-form', () ->
		toggle_review_form false
		return false
