module ContributableHelper
	def check_for_existing_contribution(entity)
    raise ArgumentError.new("'entity' must be a Contributable") unless entity.is_a? Contributable
    flash[:warning] = t 'notices.contributions.on_going' if entity.contributions.where{(whodunnit_id != "#{current_user.id}") & (state == 'pending')}.exists?
  end
end