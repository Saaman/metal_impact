class Administration::ContributionsController < ApplicationController
	load_and_authorize_resource :class => Contribution
	respond_to :html

	def index
		@contributions = Contribution.at_state(:pending).order('created_at ASC').paginate(page: params[:page]).includes(:approvable)
		respond_with @contributions
	end

	def show
		@contribution = Contribution.find params[:id]
		respond_with @contribution
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