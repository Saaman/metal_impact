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
      def contribute(can_bypass_approval = false)

				return false unless valid?

				self.transaction do

					original = self.new_record? ? nil : self.class.find(id)

					if new_record? || can_bypass_approval
						self.published = can_bypass_approval
						#Save the record
						return false if !save
					end

					contribution = Contribution.new_from self, original
					return contribution.save
				end
			end
		end
	end
end