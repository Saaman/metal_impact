module Trackable
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

			stampable

      #validations
      validates_presence_of :creator, :updater

      delegate :pseudo, :to => :updater, :prefix => true
      delegate :pseudo, :to => :creator, :prefix => true

    end
  end
end