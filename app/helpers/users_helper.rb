module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}"
    image_tag(gravatar_url, alt: user.email, class: "gravatar")
  end

  User.roles.keys.each do |role|
    method_name = ("user_is_" + role.to_s + "?").to_sym
    send :define_method, method_name do
      user_signed_in? and current_user.role == role
    end
  end

end