class AlbumsController < ApplicationController
  load_and_authorize_resource
  #Cancan breaks the mass-assignment security because music label association is not accessible
  skip_load_and_authorize_resource  :only => :create

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
      format.js { "alert('toto');" }
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
    debugger
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
    debugger
    @album = Album.new
    @album.attributes = params[:album].except(:music_label, :music_label_id)
    authorize! :create, @album
    build_or_associate_music_label(params[:album])

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
    @album.attributes = params[:album].except(:music_label, :music_label_id)

    build_or_associate_music_label(params[:album])

    respond_to do |format|
      if @album.save
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { head :no_content }
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
    def build_or_associate_music_label(params)
      if params[:music_label_id].blank?
        return if params[:music_label].blank?
        return if params[:music_label][:name].blank?
        @album.build_music_label(params[:music_label])
      else
        @album.music_label = MusicLabel.find(params[:music_label_id])
      end
    end
end
