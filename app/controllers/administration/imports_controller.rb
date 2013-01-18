class Administration::ImportsController < ApplicationController
	load_and_authorize_resource :class => Import::SourceFile
	respond_to :html
	respond_to :js, :only => :show

	def index
		 @source_files = Import::SourceFile.order("created_at DESC")
		 logger.info "#{@source_files.inspect}"
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
end
