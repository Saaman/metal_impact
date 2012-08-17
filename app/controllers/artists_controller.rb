class ArtistsController < ApplicationController
  load_and_authorize_resource
  respond_to :json, :html

  # GET /artists/search
  # GET /artists/search.json
  def search
  	@artists = Artist.where("name LIKE ?", "%#{params[:name_like]}%")
  	@artists = @artists.limit(5) if params["format"] == "json"

  	logger.info "@artists = #{@artists}"

  	respond_with @artists do |format|
      format.json { render :json => @artists.map{ |a| {name: a.name, id: a.id} } }
    end
  end

  def smallblock
  	artist = Artist.find(params[:id])
  	logger.info "@artist = #{artist}"
  	respond_with artist do |format|
  		format.html { render :layout => false }
  	end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = Artist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @artist }
    end
  end

end