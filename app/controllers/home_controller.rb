class HomeController < ApplicationController
	authorize_resource :class => false
	skip_authorization_check :only => :index

	respond_to :html, :only => :index
  respond_to :js, :only => :show_image

	def index
	end

	def show_image
		@image_link = Rack::Utils.unescape params["image_link"]
		respond_with @image_link
	end
end
