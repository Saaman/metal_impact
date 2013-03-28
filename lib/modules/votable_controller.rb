module VotableController
	def self.included(klazz)  # klazz is that class object that included this module
		klazz.class_eval do

			respond_to :json, :only => [:upvote, :downvote]

			def upvote
				respond_to_vote true
			end

			def downvote
				respond_to_vote false
			end

			private
				def respond_to_vote(positive)
					@votable = votable_model_class.find(params[:id])
					@votable.class.public_activity_off

					res = if ( current_user.voted_as_when_voted_for(@votable) == positive )
						@votable.unvote :voter => current_user, :vote => positive
					else
						@votable.vote :voter => current_user, :vote => positive
					end

					if res
						respond_with @votable do |format|
							format.json { render :json => @votable.json_presenter(current_user.voted_on? @votable) }
						end
					end

					@votable.class.public_activity_on
				end
		end
	end
end