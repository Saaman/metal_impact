module ApplicationHelper

	#this method should be used instead of 'yield' when using content_for with partial layouts
	def yield_content!(content_key)
    view_flow.content.delete(content_key)
  end

  def normal_image_tag(mount_uploader, options = {})
    link_to show_image_path(image_link: Rack::Utils.escape(mount_uploader.url)), :remote => true, "data-toggle" => "modal", "data-target" => "div#modal-image" do
      image_tag mount_uploader.normal.url, options
    end
  end

  def user_is_admin?
    user_signed_in? ? (current_user.admin?) : false
  end

  def map_alert_keys(key)
    key = key.to_sym unless key.is_a? Symbol
    return 'error' if key == :alert
    return 'info' if key == :notice
    key
  end

  def can_debug?
    Rails.cache.fetch(:allow_debug) && user_is_admin?
  end

end
