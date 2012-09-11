#$LOAD_PATH.unshift(File.dirname(__FILE__))

#require 'has_contributions'

#$LOAD_PATH.shift

module HasContributions
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

			#associations
			has_many :approvals, :as => :approvable
	 	end
  end
end