class Administration::ContributionsController < ApplicationController
	load_and_authorize_resource :class => Contribution
	respond_to :html

	def index
		@contributions = Contribution.at_state(:pending).order('created_at ASC').paginate(page: params[:page]).includes(:creator)
		respond_with @contributions
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