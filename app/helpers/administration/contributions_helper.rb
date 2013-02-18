module Administration
	module ContributionsHelper
		def translate_object_kind(object_type)
			t("activerecord.models.#{object_type.downcase}").camelize
		end

		def display_event(contribution)
			event_label = t_enum contribution, :event
			event_class =  case contribution.event
				when :create then 'label-success'
				else 'label-info'
			end
			content_tag :span, event_label, class: "label #{event_class}"
		end

		def render_line_block_for(contribution)
			partial_type = case contribution.approvable_type
				when Artist.name then 'artist'
				else 'product'
			end

			render partial: "#{partial_type}_line_block", locals: {"#{partial_type}".to_sym => contribution.approvable }
		end
	end
end