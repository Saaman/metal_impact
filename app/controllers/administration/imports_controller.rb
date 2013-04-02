class Administration::ImportsController < ApplicationController
	load_and_authorize_resource :class => Import::SourceFile
	respond_to :html
	respond_to :js, :only => :show

	def index
		add_new_files_from_gdrive

		@source_files = Import::SourceFile.order("created_at DESC")
    respond_with @source_files
	end

	def show
		@source_file = Import::SourceFile.find(params[:id])
		@source_file.refresh_status
    respond_with @source_file do |format|
    	format.js { render 'show', layout: false }
    end
	end

	def update
		@source_file = Import::SourceFile.find(params[:id])
		@source_file.refresh_status
		@source_file.set_source_type_and_load_entries params[:import_source_file][:source_type]
		redirect_to :action => :show
	end

	def prepare
		@source_file = Import::SourceFile.find(params[:id]).prepare
		redirect_to :action => :show
	end

	def import
		import_command = ImportCommandPresenter.new params[:import_source_file][:import_command]
		@source_file = Import::SourceFile.find(params[:id]).import import_command.entries_count, import_command.entries_type
		redirect_to :action => :show
	end

	def failures
		@source_file = Import::SourceFile.find params[:id]
		respond_with @source_file, :layout => false
	end

	def clear_failures
		source_file_id = params[:id]
		Import::Failure.transaction do
			Import::Failure.joins(:source_file).destroy_all('import_source_files.id' => source_file_id)
		end
		redirect_to administration_import_path(source_file_id)
	end

	private
		def add_new_files_from_gdrive
			#open a session at Google
	    session = GoogleDrive.login ENV["GD_USER"], ENV["GD_PWD"]

	    #Get all files of collection name "Fixtures v{version}" and download them
	    collection = session.files :title => "Fixtures v#{ENV["SITE_VERSION"].chomp}", "title-exact" => true, showfolders: true
	    if collection.length != 1
	      flash[:error] = "collection 'Fixtures v#{ENV["SITE_VERSION"]}' was not found"
	      redirect_to root_path
	    end

	    #get existing source files names
	    source_files_names = Import::SourceFile.pluck(:path)

	    #add new source files
	    collection[0].files.each do |file|
	    	next if source_files_names.include?(file.title)
      	sf = Import::SourceFile.new path: file.title
      	sf.save!
      end
		end
end
