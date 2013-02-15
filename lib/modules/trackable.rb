module Trackable
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

			include PublicActivity::Model
  		tracked owner: Proc.new{ |controller, model| controller.nil? ? nil : controller.current_user }

    end
  end
end