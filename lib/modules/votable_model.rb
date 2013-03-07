module VotableModel
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

      #can be voted
      acts_as_votable

  		def votes_ratio
        return 0 if cached_votes_total == 0
        cached_votes_up * 100 / cached_votes_total
      end

      def json_presenter
        #TODO : do I need a reload to get updated cached values?
        { votes_up: cached_votes_up, votes_down: cached_votes_down, votes_ratio: votes_ratio }
      end

    end
  end
end
