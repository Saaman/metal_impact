module Administration
	module ImportsHelper
		def display_entries(entries_count)
			return t("defaults.none") if (entries_count == 0)
			t 'administration.imports.defaults.entries', count: entries_count
		end
		def display_state(state_name)
			state_label = t "activerecord.states.import.source_file.#{state_name}"
			state_class = case state_name
				when :new then ""
				else "label-info"
			end
			content_tag :span, state_label, class: "label #{state_class}"
		end
		def display_source_type(source_type)
			return t("defaults.none") unless source_type
			Import::SourceFile.human_enum_name(:source_types, source_type)
		end
		def load_file_button(form, source_file)
			options = {:class => 'btn-primary'}
			return form.button :submit, t('helpers.submit.import_source_file.reload'), options if source_file.can_unload_file?
			form.button :submit, options
		end
	end
end