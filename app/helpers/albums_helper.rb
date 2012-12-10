module AlbumsHelper
	def artists_links_for(album)
		return t("special.various_artists").upcase if album.artists.size > 3
		safe_join(album.artists.collect {|a| link_to(a.name.upcase, a) }, " - ")
	end
end