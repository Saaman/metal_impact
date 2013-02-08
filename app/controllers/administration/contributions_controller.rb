class Administration::ContributionsController < ApplicationController
	load_and_authorize_resource :class => Contribution
	respond_to :html

	def index
	end

	def show
	end

	def edit
	end

	def update
	end

	def approve
	end

	def refuse
	end
end