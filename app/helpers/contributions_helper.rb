module ContributionsHelper

	def contribute_with(object)

		raise Exceptions::HasContributionsError.new("Object of type '#{object.nil? ? nil : object.class.name.humanize}' does not support contributions mechanism") unless object.kind_of? HasContributions

		return(false) unless object.valid?

		logger.info "can? :bypass_approval, object : #{can? :bypass_approval, object}"

		if can? :bypass_approval, object
			#TODO : check if it's transactional or not. It should be
			logger.info "save(object) : #{save(object)}"
			logger.info "reward_contribution(object) : #{reward_contribution(object)}"
			return save(object) && reward_contribution(object)
		end
		logger.info "Je vais sauvegarder le record"
		logger.info "not object.new_record?: #{not object.new_record?}"
		return request_approval(object) && ((not object.new_record?) || save(object))
	end

	private
		def save(object)
			logger.info "Je suis dans save!"
			object.published ||= can? :bypass_approval, object
			object.save
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
end