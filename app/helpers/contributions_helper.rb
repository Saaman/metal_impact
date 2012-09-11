module ContributionsHelper

	def add_contribution(object)

		return object.save if can? :bypass_approval, object
		return false unless object.valid?

		original = object.new_record? ? nil : object.class.find(object.id)
		logger.info "#{original.inspect}"

		object.save if object.new_record?

		Approval.new approvable: object, original: original, object: object

	end
end