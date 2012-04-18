module ApplicationHelper
	
  def store_back_uri
		session[:back_uri] = request.url
	end
	def get_back_uri
		session[:back_uri] || root_path
	end
end
