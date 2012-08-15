class AlbumsController < ApplicationController
  load_and_authorize_resource
  #Cancan breaks the mass-assignment security because music label association is not accessible
  skip_load_and_authorize_resource  :only => :create

  #TODO embbed the create_new_label hidden field into album form sub-hash
  
  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/new
  # GET /albums/new.json
  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.new
    build_or_update_album(params)
    authorize! :create, @album #TODO : vérifier pourquoi on reauthorize ici
    
    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully created.' }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /albums/1
  # PUT /albums/1.json
  def update

    @album = Album.find(params[:id])
    build_or_update_album(params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "edit" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  private
    def build_or_update_album(params)
      @album.attributes = params[:album].slice :title, :release_date, :kind
      @album.artist_ids = params[:product][:artist_ids] if params.has_key? :product

      #manage music label
      if (params[:album].has_key?(:create_new_music_label) and params[:album][:create_new_music_label].to_bool)
        @album.build_music_label(params[:album][:music_label]) if params[:album].has_key? :music_label
      else
        @album.music_label_id = params[:album][:music_label_id] unless params[:album][:music_label_id].blank?
      end

    end
end
