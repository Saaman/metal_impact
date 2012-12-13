class MusicLabelsController < ApplicationController
	load_and_authorize_resource
  respond_to :html

  # GET /music_labels/1/smallblock
  def smallblock
    @music_label = MusicLabel.find(params[:id])
    respond_with @music_label do |format|
      format.html { render :layout => false }
    end
  end
end
