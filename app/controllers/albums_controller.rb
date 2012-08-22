class AlbumsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => :create
  respond_to :html

  # GET /albums
  def index
    @albums = Album.paginate(page: params[:page])
    respond_with @albums
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
    respond_with @album
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
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

      respond_to do |format|
        if associate_artists(params) and @album.save
          format.html { redirect_to @album, notice: t("notices.album.#{params[:action]}") }
          format.json { render json: @album, location: @album }
        else
          format.html { render action: template }
          format.json { render json: @album.errors, status: :unprocessable_entity }
        end
      end
    end

    def build_or_update_album(params)
      @album.attributes = params[:album].slice :title, :release_date, :kind, :cover

      #manage music label
      if (params[:album].has_key?(:create_new_music_label) and params[:album][:create_new_music_label].to_bool)
        @album.build_music_label(params[:album][:music_label]) if params[:album].has_key? :music_label
        authorize! :new, @album.music_label
      else
        @album.music_label_id = params[:album][:music_label_id] unless params[:album][:music_label_id].blank?
      end
    end

    def associate_artists(params)
      #return true if not artists to add. Standard validation will make the save fails
      params.has_key?(:product) ? @album.try_set_artist_ids(params[:product][:artist_ids]) : true
    end
end
