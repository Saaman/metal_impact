class Administration::ImportFailuresController < ApplicationController
	load_and_authorize_resource :class => Import::Failure
	respond_to :html

	def index
	end

	def clear
		source_file_id = params[:import_id]
		Import::Failure.transaction do
			Import::Failure.joins(:source_file).destroy_all('import_source_files.id' => source_file_id)
		end
		redirect_to administration_import_path(source_file_id)
	end
end