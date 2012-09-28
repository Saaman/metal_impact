module ContributionsHelper

	def contribute_with(object)

		raise Exceptions::ContributableError.new("Object of type '#{object.nil? ? nil : object.class.name.humanize}' does not support contributions mechanism") unless object.kind_of? Contributable

		return(false) unless object.valid?

		if can? :bypass_approval, object
			#TODO : check if it's transactional or not. It should be
			return save(object) && reward_contribution(object)
		end
		return request_approval(object) && ((not object.new_record?) || save(object))
	end

	def reward_contribution(object)
		#TODO : to be developed
		return true
	end

	def request_approval(object)
		original = object.new_record? ? nil : object.class.find(object.id)
		approval = Approval.new_from object, original
		approval.save
	end

	private
		def save(object)
			logger.info "save the object"
			if can? :bypass_approval, object
				object.published = true if object.published.nil?
				logger.info "can skip approval, so published is set to true"
			else
				object.published = false
				logger.info "cannot bypass approval, so published is set to false"
			end
			object.save
		end
end