class UtilsController < ApplicationController

	include MarkdownHelper

	authorize_resource :class => false
	respond_to :html
	layout 'markitup'

	def markdown_preview
		@content = render_markdown params[:data]
	end
end
