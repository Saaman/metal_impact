$ ->
	#Set correctly hidden value "create-new-music-label"
	$('ul#label_for_album_pills').on 'shown', 'a[data-toggle="pill"]', (e) ->
  	$('input#album_new_music_label_create_new').val($(e.target).attr('id') == "create_new_music_label_pill")

  #show tab according to create
  $('a#create_new_music_label_pill').tab('show') if $('input#album_new_music_label_create_new').val() == "true"

	#Setup dynamic loading of music label when selecting a new one
	$('select#album_music_label_id').on 'change', (e) ->
		selected_label = $(this).children 'option:selected'
		$.get '/music_labels/'+selected_label.val()+'/smallblock.html', (data) ->
    	$('div#music_label_block').html(data)

  
