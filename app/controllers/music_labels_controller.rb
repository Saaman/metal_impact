class MusicLabelsController < ApplicationController
	load_and_authorize_resource
	
	# GET /albums/new
  def new
    @musicLabel = MusicLabel.new
    head :ok
  end

  def create
  	head :ok
  end
end
