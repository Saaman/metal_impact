module Contributable
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

			include Trackable

			#associations
			has_many :contributions, :as => :approvable

			#attributes
			#Considering default value set in DB, published is set to 'false' by default
      attr_accessible :published

      #validations
      validates :published, :inclusion => { :in => [true, false] }

      scope :published, where(:published => true)

      def flash_key
      	@flash_key
      end

      def flash_msg
      	@flash_msg
      end

      #methods
      def publish!(updated_at_value = nil)
      	self.published = true
      	if updated_at_value.nil?
      		save!
      	else
      		self.updated_at = updated_at_value
      		save_without_timestamping!
      	end
      end

      def contribute(contributor, can_bypass_approval = false)
      	raise ArgumentError.new('Contributor must be a valid user') if (contributor.nil? || contributor.new_record?)
      	return false unless valid?

      	is_new_record = new_record?
      	published = false

      	return false unless valid?

      	self.transaction do

	      	#save the record if new
	      	if is_new_record
	      		return false unless save #return false if save fails
	      	end

	      	#create a contribution and save it
					contribution = make_contribution contributor, is_new_record
					return false unless contribution.save

					#commit the contribution if necessary rights
					if can_bypass_approval && contribution.can_approve?
						@flash_key = :notice
						@flash_msg = I18n.t("notices.#{self.class.name.downcase}.#{contribution.event}")
						return contribution.approve
					end

					@flash_key = :warning
					@flash_msg = I18n.t("notices.#{self.class.name.downcase}.contribute")
					return true
				end
			end

			def apply_contribution(attrs)
				attrs.each do |key, value|
					self.send "#{key}=", value
				end
				return self
			end

			#private
				def make_contribution(contributor, is_new_record)
					raise RuntimeError.new('Cannot issue a contribution on a object not saved yet') if self.new_record?
					attrs = self.attributes
					attrs .merge! specific_attributes_for_contribution
					Contribution.for self, attrs, contributor, is_new_record
				end

				def specific_attributes_for_contribution
					{}
				end
		end
	end
end