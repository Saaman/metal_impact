module SitewideHtmlHelper
	def sorting_select(object, method, sort_presenter, url)
		raise ArgumentError.new "'#{sort_presenter.inspect}' is not a SortPresenter object" unless sort_presenter.is_a? SortPresenter
		select object, method, sort_presenter.options_for_select, {:selected => sort_presenter.sort_by}, {class: 'sorting_select', style: 'margin-bottom: 0px;', "reload-url" => url}
	end

	def votes_ratio(votable)
		return 0 if votable.cached_votes_total == 0
		votable.cached_votes_up * 100 / votable.cached_votes_total
	end
end