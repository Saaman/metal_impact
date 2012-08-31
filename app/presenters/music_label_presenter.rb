class MusicLabelPresenter
	attr_accessor :music_label, :create_new

	def initialize(params = {})
		@music_label = MusicLabel.new(params[:music_label])
		@create_new = params[:create_new] || false
	end
end