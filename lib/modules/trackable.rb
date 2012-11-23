module Trackable
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

			stampable

			#callbacks
      after_save do |trackable|
        raise Exceptions::TrackableError.new("You can't create a '#{trackable.class.name.humanize}' without creator") if trackable.creator.nil?
        raise Exceptions::TrackableError.new("You can't update a '#{trackable.class.name.humanize}' without updater") if trackable.updater.nil?
      end

      delegate :pseudo, :to => :updater, :prefix => true

    end
  end
end