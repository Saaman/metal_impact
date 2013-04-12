class AlbumsController < ApplicationController

  include ContributableHelper
  include VotableController

  load_and_authorize_resource
  skip_load_resource :only => :create
  respond_to :html

  SORTING_FILTERS ||= {created_at_desc: 'created_at DESC', created_at_asc: 'created_at ASC', title_asc: 'title ASC', title_desc: 'title DESC'}

  # GET /albums
  def index
    @sort_presenter = SortPresenter.new SORTING_FILTERS.keys, params['sort_order']
    @albums = Album.published.order(SORTING_FILTERS[@sort_presenter.sort_by]).paginate(page: params[:page]).includes(:artists)
    respond_with @albums, layout: !request.xhr?
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @album = Album.find(params[:id])
    respond_with @album
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new
    @new_music_label = MusicLabelPresenter.new
    respond_with @album
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
    check_for_existing_contribution @album
    @new_music_label = MusicLabelPresenter.new
    respond_with @album
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new
    create_or_update_album(params, "new")
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update

    @album = Album.find(params[:id])
    create_or_update_album(params, "edit")
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    respond_with @album do |format|
      format.html { redirect_to albums_url }
    end
  end

  private

    def create_or_update_album(params, template)
      build_or_update_album(params)

      if @album.contribute(current_user, can?(:bypass_contribution, @album))
        make_flash_for_contribution @album
        respond_with @album
      else
        respond_with @album do |format|
          format.html { render template }
        end
      end
    end

    def build_or_update_album(params)

      @album.attributes = params[:album].slice :title, :release_date, :kind, :cover, :music_genre_id

      #manage music label
      @new_music_label = MusicLabelPresenter.new params[:album][:new_music_label]
      if @new_music_label.create_new
        authorize! :new, @new_music_label.music_label
        @album.music_label = @new_music_label.music_label
      else
        @album.music_label_id = params[:album][:music_label_id] unless params[:album][:music_label_id].blank?
      end

      #manage artists
      if params.has_key?(:product)
        @album.artist_ids = params[:product][:artist_ids]
        true
      else
        @album.errors.add(:artist_ids, :too_short)
      end

    end

    protected
    def votable_model_class
      Album
    end
end
