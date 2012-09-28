module Contributable
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

      #Considering default value set in DB, published is set to 'false' by default

			#associations
			has_many :approvals, :as => :approvable

			#attributes
      attr_accessible :published

      #validations
      validates :published, :inclusion => { :in => [true, false] }
	 	end
  end
end