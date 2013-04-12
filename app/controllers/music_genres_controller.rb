class MusicGenresController < ApplicationController
	load_and_authorize_resource
  respond_to :json, :only => :search

  def search
    search_pattern = params[:search_pattern] || ''
    @music_genres = (search_pattern.size > 1) ? MusicGenre.with_translations(I18n.locale).where{translations.name.like my{"%#{search_pattern}%"}}.limit(15) : []

  	respond_with @music_genres do |format|
      format.json { render :json => @music_genres.map{ |mg| {name: mg.name, id: mg.id} } }
    end
  end
end
