$ ->
	#Set correctly hidden value "create-new-music-label"
	$('ul#label_for_album_pills').on 'show', 'a[data-toggle="pill"]', (e) ->
		show_new_label_form = $(e.target).attr('id') == "create_new_music_label_pill"
		$('input#album_new_music_label_create_new').val show_new_label_form
		#disable fields so that client-side validations works on what is shown only
		$('div#label_form input').prop 'disabled', not show_new_label_form
		$('div#label_finder input').prop 'disabled', show_new_label_form

	#show tab according to create_new hidden field
	$('a#create_new_music_label_pill').tab('show') if $('input#album_new_music_label_create_new').val() == "true"
	$('a#select_existing_label_pill').tab('show') if $('input#album_new_music_label_create_new').val() == "false"

	#Setup dynamic loading of music label when selecting a new one
	$('select#album_music_label_id').on 'change', (e) ->
		selected_label = $(this).children 'option:selected'
		$.get '/music_labels/'+selected_label.val()+'/smallblock.html', (data) ->
			$('div#music_label_block').html(data)

	# labels typeahead
	$('input#label_typeahead').typeahead(
		# source can be a function
		source: (typeahead, query) ->
			$.getJSON '/music_labels/search.json', {'search_pattern': query}, (data) =>
				# data must be a list of either strings or objects
				typeahead.process(data)
		# if we return objects to typeahead.process we must specify the property
		# that typeahead uses to look up the display value
		property: 'name'
		onselect: (obj) ->
			$.get '/music_labels/' + obj.id + '/smallblock.html', (data) ->
				$('div#music_label_block').html(data)
				#update hidden field for form submission
				$('input#album_music_label_id').val(obj.id)
		)

	# music_genres typeahead
	$('input#music_genre_typeahead').typeahead(
		source: (typeahead, query) ->
			$.getJSON '/music_genres/search.json', {'search_pattern': query}, (data) =>
				typeahead.process(data)
		property: 'name'
		onselect: (obj) ->
			$('div#music_genre_display strong').text obj.name
			#update hidden field for form submission
			$('input#album_music_genre_id').val obj.id
			show_music_genre_input false
		)

	#setup display of music_genre
	show_music_genre_input( $('input#album_music_genre_id').val() == '' )
	#toggle display of music_genre
	$('div#music_genre_display span.clickable').on 'click', () ->
		show_music_genre_input true
	$('div#music_genre_input').on 'click', 'button', () ->
		show_music_genre_input false

show_music_genre_input = (show) ->
	$('input#music_genre_input').val $('input#music_genre_input').attr('placeholder')
	$('div#music_genre_display').toggle(!show)
	$('div#music_genre_input').toggle(show)
