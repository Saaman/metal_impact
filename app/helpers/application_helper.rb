module ApplicationHelper
	
  def store_back_uri
		session[:back_uri] = request.url
	end
	def get_back_uri
		session[:back_uri] || root_path
	end

	#this method should be used instead of 'yield' when using content_for with partial layouts
	def yield_content!(content_key)
    view_flow.content.delete(content_key)
  end
end
