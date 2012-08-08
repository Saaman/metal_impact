class ArrayInclusionValidator < ActiveModel::EachValidator
	#only works with string array.
	#we expect the option[:in] inclusin array to be upcased
  def validate_each(record, attribute, value)
  	return if value.blank?
    value.each do |v|
      record.errors.add(attribute, :array_inclusion, :value => v) unless options[:in].include?(v.upcase)
    end
  end
end