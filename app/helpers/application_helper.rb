module ApplicationHelper
	
	#this method should be used instead of 'yield' when using content_for with partial layouts
	def yield_content!(content_key)
    view_flow.content.delete(content_key)
  end

  def normal_image_tag(mount_uploader, options = {})
    link_to show_image_path(image_link: Rack::Utils.escape(mount_uploader.url)), :remote => true, class: "modal-trigger" do 
      image_tag mount_uploader.normal.url, options
    end
  end

  User.roles.keys.each do |role|
    method_name = ("user_is_" + role.to_s + "?").to_sym
    send :define_method, method_name do
      user_signed_in? ? (current_user.role == role) : false
    end
  end
end
