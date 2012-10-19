class ArtistsController < ApplicationController

  include ContributionsHelper

  load_and_authorize_resource
  respond_to :html
  respond_to :json, only: [:search, :show]
  respond_to :js, :only => [:new, :create]

  # GET /artists
  def index
    @artists = Artist.published.order("updated_at DESC").paginate(page: params[:page])
    respond_with @artists
  end

  # GET /artists/search
  # GET /artists/search.json
  def search
       
    @artists = Artist.where{name.like my{"%#{params[:name_like]}%"}}

    limit_search_for_product_type = params["for-product"]
    unless limit_search_for_product_type.blank?
      raise "'#{limit_search_for_product_type}' is not a known product type." unless Artist::PRODUCT_ARTIST_PRACTICES_MAPPING.has_key? limit_search_for_product_type.to_sym
      #limit on artists having practices compliant with product type
      @artists = @artists.operates_as(Artist::PRODUCT_ARTIST_PRACTICES_MAPPING[limit_search_for_product_type.to_sym])
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
    @product_type_targeted = params[:product_type]
    respond_with @artist
  end

  def create
    @artist = Artist.new
    @artist.attributes = params[:artist].slice :name, :practice_ids, :biography, :countries
    @product_type_targeted = params[:product_type_targeted]

    checkObj = @artist.is_suitable_for_product_type(@product_type_targeted)

    if checkObj[:error]
      respond_with @artist do |format|
        logger.info "errors : #{@artist.errors.full_messages}"
        format.html { render :action => :new }
        format.js  { render 'new' }
      end
    end

    respond_with @artist do |format|
      if contribute_with(@artist)
        format.html { redirect_to @artist, notice: t("notices.artist.#{params[:action]}") }
      else
        logger.info "errors : #{@artist.errors.full_messages}"
        format.html { render :action => :new }
        format.js  { render 'new' }
      end
    end
  end

end