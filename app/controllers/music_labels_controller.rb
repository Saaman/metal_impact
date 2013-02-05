class MusicLabelsController < ApplicationController
	load_and_authorize_resource
  respond_to :html
  respond_to :json, :only => :search

  # GET /music_labels/1/smallblock
  def smallblock
    @music_label = MusicLabel.find(params[:id])
    respond_with @music_label do |format|
      format.html { render :layout => false }
    end
  end

  # GET /music_labels/search
  # GET /music_labels/search.json
  def search
    search_pattern = params[:search_pattern] || ''
    @music_labels = (search_pattern.size > 1) ? MusicLabel.where{name.like my{"%#{search_pattern}%"}}.limit(5) : []

  	respond_with @music_labels do |format|
      format.json { render :json => @music_labels.map{ |ml| {name: ml.name, id: ml.id} } }
    end
  end
end
