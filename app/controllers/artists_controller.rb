class ArtistsController < ApplicationController
  load_and_authorize_resource
  respond_to :html
  respond_to :json, only: [:search, :show]

  # GET /artists/search
  # GET /artists/search.json
  def search
       
    @artists = Artist.where{name.like my{"%#{params[:name_like]}%"}}

    limit_search_for_product_type = params["for-product"]
    unless limit_search_for_product_type.blank?
      raise "'#{limit_search_for_product_type}' is not a known product type." unless Productable::PRODUCT_ARTIST_PRACTICES_MAPPING.has_key? limit_search_for_product_type.to_sym
      #limit on artists having practices compliant with product type
      @artists = @artists.operates_as(Productable::PRODUCT_ARTIST_PRACTICES_MAPPING[limit_search_for_product_type.to_sym])
    end

  	respond_with @artists do |format|
      format.json { render :json => @artists.limit(5).map{ |a| {name: a.name, id: a.id} } }
    end
  end

  # GET /artists/1/smallblock
  def smallblock
  	@artist = Artist.find(params[:id])
  	respond_with @artist do |format|
  		format.html { render :layout => false }
  	end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @artist = Artist.find(params[:id])
  end

  def new
    @artist = Artist.new
    respond_with @artist
  end

end