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
		def preparation_progress(source_file)
			0 if source_file.overall_progress == 100
			[20, source_file.overall_progress].min
		end
		def import_progress(source_file)
			100 if source_file.overall_progress == 100
			[0, source_file.overall_progress-20].max
		end
		def pending_progress(source_file)
			0
		end
		def error_progress(source_file)
			source_file.failures.count * source_file.overall_progress / source_file.entries_count
		end
	end
end