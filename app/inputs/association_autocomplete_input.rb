class AssociationAutocompleteInput < SimpleForm::Inputs::Base
  def input
    "#{@builder.text_field(attribute_name, input_html_options.merge({ :value => '' }))}".html_safe
  end
end