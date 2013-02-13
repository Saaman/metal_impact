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

      #methods
      def publish!
      	self.published = true
      	save!
      end

      def contribute(can_bypass_approval = false)
      	return false unless valid?

      	is_new_record = new_record?
      	published = false

      	self.transaction do

	      	#save the record if new
	      	if is_new_record
	      		return false unless save #return false if save fails
	      	end

	      	#create a contribution and save it
					contribution = make_contribution is_new_record
					return false unless contribution.save

					#commit the contribution if necessary rights
					if can_bypass_approval && contribution.can_approve?
						return contribution.approve
					end

					return true
				end
			end

			def apply_contribution(attrs)
				attrs.each do |key, value|
					self.send "#{key}=", value
				end
			end

			#private
				def make_contribution(is_new_record)
					raise RuntimeError.new('Cannot issue a contribution on a object not saved yet') if self.new_record?
					attrs = self.attributes
					attrs .merge! specific_attributes_for_contribution
					Contribution.for self, attrs, is_new_record
				end

				def specific_attributes_for_contribution
					{}
				end
		end
	end
end