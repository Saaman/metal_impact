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
		unless @source_file.new?
			redirect_to :action => :show
		else
    	respond_with @source_file
    end
	end
end
