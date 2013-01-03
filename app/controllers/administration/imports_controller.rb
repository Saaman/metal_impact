class Administration::ImportsController < ApplicationController
	load_and_authorize_resource :class => Import::SourceFile
	respond_to :html

	def index
		 @source_files = Import::SourceFile.order("created_at DESC")
		 logger.info "#{@source_files.inspect}"
    respond_with @source_files
	end

	def show
		@source_file = Import::SourceFile.find(params[:id])
		@source_file.refresh_status
    respond_with @source_file
	end

	def update
		@source_file = Import::SourceFile.find(params[:id])
		@source_file.refresh_status
		if @source_file.set_source_type_and_load_entries params[:import_source_file][:source_type]
			redirect_to :action => :show
		else
			respond_with @source_file do |format|
				format.html { render 'edit' }
			end
		end
	end

	def prepare
		@source_file = Import::SourceFile.find(params[:id]).prepare
		redirect_to :action => :show
	end
end
