class Administration::ImportEntriesController < ApplicationController
	load_and_authorize_resource :class => Import::Entry
	respond_to :html

	def edit
		@entry = Import::Entry.find(params[:id])
		respond_with @entry, :layout => false
	end

	def update
	end
end