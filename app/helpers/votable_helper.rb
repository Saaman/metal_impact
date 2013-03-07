module VotableHelper
	def additive_voted_class(votable, vote_result=true)
		(current_user.voted_as_when_voted_for(votable) == vote_result) ? " voted" : ""
	end

	def vote_up_path(votable)
		self.send "upvote_#{votable.class.name.downcase}_path"
	end

	def vote_down_path(votable)
		self.send "downvote_#{votable.class.name.downcase}_path"
	end
end