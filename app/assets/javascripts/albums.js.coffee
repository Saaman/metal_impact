$ ->
	#Set correctly hidden value "create-new-music-label"
	$('#label_for_album_pills').on 'shown', 'a[data-toggle="pill"]', (e) ->
  	$('#album_create_new_music_label').val($(e.target).attr('id') == "create_new_music_label_pill")

  #show tab according to create
  $('#create_new_music_label_pill').tab('show') if $('#album_create_new_music_label').val() == true

	#Setup dynamic loading of music label when selecting a new one
	$('#album_music_label_id').on 'change', (e) ->
		selected_label = $(this).children 'option:selected'
		$.get '/music_labels/'+selected_label.val()+'/smallblock.html', (data) ->
    	$('#music_label_block').html(data)

  
