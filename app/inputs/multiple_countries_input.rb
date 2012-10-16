class MultipleCountriesInput < SimpleForm::Inputs::Base
	def input
    @builder.country_code_select(attribute_name, nil, {}, input_html_options.merge({:multiple => 'multiple'}))
  end
end