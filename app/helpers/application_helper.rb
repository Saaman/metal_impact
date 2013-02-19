module ApplicationHelper

	#this method should be used instead of 'yield' when using content_for with partial layouts
	# def yield_content!(content_key)
 #    view_flow.content.delete(content_key)
 #  end

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
    case key
    when :alert then 'alert-error'
    when :notice then 'alert-info'
    when :warning then ''
    else "alert-#{key}"
    end
  end

  def can_debug?
    Rails.env.development? || (Rails.cache.fetch(:allow_debug) && user_is_admin?)
  end

  def set_debug(value)
    Rails.cache.write(:allow_debug, value, :expires_in => 1.day)
  end

  #views helpers
  def t_attr_show(model_or_instance, method)
    "#{t_attr(model_or_instance, method).camelize} : "
  end
  def t_attr(model_or_instance, method)
    model_name = model_or_instance.is_a?(String) ? model_or_instance : model_or_instance.class.model_name.i18n_key
    t "activerecord.attributes.#{model_name}.#{method}"
  end
  def t_enum(instance, enum_attr_name, options = {})
    I18n.t_enum instance, enum_attr_name, options
  end
end
