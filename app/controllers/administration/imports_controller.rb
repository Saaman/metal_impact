class Administration::ImportsController < ApplicationController
	load_and_authorize_resource :class => Import::SourceFile
	respond_to :html

	def index
		 @source_files = Import::SourceFile.order("created_at DESC")
    respond_with @source_files
	end

	def show
	end
end
