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

					if @votable.vote :voter => current_user, :vote => positive
						respond_with @votable do |format|
							format.json { render :json => @votable.json_presenter }
						end
					end
				end
		end
	end
end