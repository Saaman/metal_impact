module Administration
	module ImportsHelper
		def display_entries(entries_count)
			return t("defaults.none") if (entries_count == 0)
			t 'administration.imports.defaults.entries', count: entries_count
		end
		def display_state(source_file)
			state_label = t "activerecord.states.import.source_file.#{source_file.state_name}"
			state_class = (source_file.has_failures? && "label-important") || case source_file.state_name
				when :new then ''
				when :imported then 'label-success'
				when *Import::SourceFile::PENDING_STATES then 'label-warning'
				else 'label-info'
			end
			content_tag :span, state_label, class: "label #{state_class}"
		end
		def load_file_button(form, source_file)
			options = {:class => 'btn-primary'}
			return form.button :submit, t('helpers.submit.import_source_file.reload'), options if source_file.can_unload_file?
			form.button :submit, options
		end

		def preparation_progress(source_file)
			0 if source_file.overall_progress == 100
			[30, source_file.overall_progress].min
		end

		def import_progress(source_file)
			100 if source_file.overall_progress == 100
			[0, source_file.overall_progress-pending_progress(source_file)-30].max
		end

		def pending_progress(source_file)
			source_file.pending_progress
		end

		def error_progress(source_file)
			return 0 if source_file.entries_count == 0
			source_file.failed_entries_count * Import::SourceFile::STATE_VALUES[source_file.state_name]*10 / source_file.entries_count
		end

		def display_entries_counts_by_target_model(source_file)
			return t('defaults.no_details') if source_file.entries_types_counts.blank?
			parts = []
			source_file.entries_types_counts.each_pair do |k,v|
				key = Import::Entry.target_models.key(k)
				raise "'#{k}' does not match any declared entry target model" if key.nil?
				parts << Import::Entry.human_enum_name(:target_models, key, {count: v})
			end
			parts.join(", ")
		end
	end
end