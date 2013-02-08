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

				self.transaction do

					contribution = Contribution.new object: self
					return false if !contribution.save

					if can_bypass_approval
						self.published = true
						#Save the record
						return false if !save
					end

					return true
				end
			end
		end
	end
end