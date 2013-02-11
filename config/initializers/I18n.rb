module I18n
  def self.t_enum(instance, enum_attr_name, options = {})
    attr_value = instance.send(enum_attr_name)
    return options[:default] if attr_value.nil? #returns nil if no option provided
    instance.class.human_enum_name enum_attr_name.to_s.pluralize, attr_value
  end
end