class CustomConfirmationValidator < ActiveModel::Validations::ConfirmationValidator
	def validate_each(record, attribute, value)
		if (confirmed = record.send("#{attribute}_confirmation")) && (value != confirmed)
			record.errors.add(:"#{attribute}_confirmation", "Is not good", options)
		end
	end
end