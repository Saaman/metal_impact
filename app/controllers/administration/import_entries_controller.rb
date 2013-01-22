class Administration::ImportEntriesController < ApplicationController
	load_and_authorize_resource :class => Import::Entry
	respond_to :html, :only => [:edit]
	respond_to :js

	def edit
		@entry = Import::Entry.find(params[:id])
		respond_with @entry, :layout => false
	end

	def update
		@entry = Import::Entry.find(params[:id])

		if @entry.update_data(params[:import_entry][:data])
			respond_with @entry.source_file do |format|
				format.js { render :js => "window.location.href = '#{administration_import_path(@entry.source_file)}'" }
			end
		else
			respond_with @entry do |format|
				format.html { render 'edit' }
			end
		end
	end
end