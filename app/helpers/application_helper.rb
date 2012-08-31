module ApplicationHelper
	
	#this method should be used instead of 'yield' when using content_for with partial layouts
	def yield_content!(content_key)
    view_flow.content.delete(content_key)
  end

  User.roles.keys.each do |role|
    method_name = ("user_is_" + role.to_s + "?").to_sym
    send :define_method, method_name do
      user_signed_in? ? (current_user.role == role) : false
    end
  end
end
