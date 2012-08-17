module ApplicationHelper
	
	#this method should be used instead of 'yield' when using content_for with partial layouts
	def yield_content!(content_key)
    view_flow.content.delete(content_key)
  end
end
