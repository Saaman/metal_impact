class MusicLabelPresenter
	attr_accessor :music_label, :create_new

	def initialize(params = {})
		@music_label = (params[:music_label].blank? && MusicLabel.new) || MusicLabel.new(params[:music_label].slice(:name, :distributor, :website))
		@create_new = params[:create_new] || false
	end
end