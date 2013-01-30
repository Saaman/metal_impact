module ContributionsHelper

	def contribute_with(object)

		raise Exceptions::ContributableError.new("Object of type '#{object.nil? ? nil : object.class.name.humanize}' does not support contributions mechanism") unless object.kind_of? Contributable

		return(false) unless object.valid?

		begin
			ActiveRecord::Base.transaction do
				if can? :bypass_contribution, object
					return save(object) && reward_contribution(object)
				end

				original = object.new_record? ? nil : object.class.find(object.id)
				return ((not object.new_record?) || save(object)) && request_contribution(object, original)
			end
		rescue => exception
			logger.info "an exception occured : #{exception.message}"
			flash[:error] = t 'exceptions.default'
			return false
		end
	end

	def reward_contribution(object)
		#TODO : to be developed
		return true
	end

	private

		def request_contribution(object, original)
			contribution = Contribution.new_from object, original
			contribution.save!
		end

		def save(object)
			object.published = can? :bypass_contribution, object
			object.save!
		end
end