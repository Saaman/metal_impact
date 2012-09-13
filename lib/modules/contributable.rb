module Contributable
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

			#associations
			has_many :approvals, :as => :approvable

			#attributes
      attr_accessible :published

      #validations
      validates :published, presence: true
	 	end
  end
end