module ApplicationHelper
	# return logo html insert
  def logo
	image_tag("logo.png", alt: "In Construction")
  end

  def store_back_uri
		session[:back_uri] = request.url
	end
	def get_back_uri
		session[:back_uri] || root_path
	end
end
