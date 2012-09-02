def build_params_for_albums_controller(album = Album.new, artist_ids = nil, create_new = false, new_music_label = MusicLabel.new)
	p = { :album => album.attributes, :product => {artist_ids: artist_ids} }
	p[:album][:kind] = album.kind
	p[:album][:new_music_label] = { create_new: create_new, music_label: new_music_label.attributes }
	p
end