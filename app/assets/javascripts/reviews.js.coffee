$ ->
	$('form#add_review').on {
		'ajax:success': (event, data) ->
			$('div#reviews-list').append data
			$('form#add_review').hide()
			$('textarea#review_body').markItUp mySettings
		}

	$('body').on 'click', 'div#new-review-form a#cancel-form', () ->
		$('div#new-review-form').remove()
		$('form#add_review').show()
		return false

	$('body').on {
	'ajax:success': (event, data, a, b, c) ->
		$('div#new-review-form').remove()
		$('form#add_review').hide()
		$('div#reviews-list').append data
	}, 'form#new_review'
