class Administration::ImportEntriesController < ApplicationController
	load_and_authorize_resource :class => Import::Entry
	respond_to :html

	def edit
	end

	def update
	end
end