class Administration::ImportsController < ApplicationController
	load_and_authorize_resource :class => Import::SourceFile
	respond_to :html

	def index
		 @source_files = Import::SourceFile.order("created_at DESC")
    respond_with @source_files
	end

	def show
		@source_file = Import::SourceFile.find(params[:id])
		if @source_file.new?
			redirect_to :action => :edit
		else
    	respond_with @source_file
    end
	end

	def edit
		@source_file = Import::SourceFile.find(params[:id])
		unless @source_file.can_set_source_type?
			redirect_to :action => :show
		else
    	respond_with @source_file
    end
	end

	def update
		@source_file = Import::SourceFile.find(params[:id])
		if @source_file.set_source_type_and_load_entries params[:import_source_file][:source_type]
			redirect_to :action => :show
		else
			respond_with @source_file do |format|
				format.html { render 'edit' }
			end
		end
	end
end
