module Administration
	module MonitoringHelper
		def toggle_debug_button_text(allow_debug)
			t "administration.monitoring.dashboard.#{allow_debug ? "de" : ""}activate_debug"
		end
	end
end