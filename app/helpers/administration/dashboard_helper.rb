module Administration
	module DashboardHelper
		def toggle_debug_button_text(allow_debug)
			t "administration.dashboard.index.#{allow_debug ? "de" : ""}activate_debug"
		end
	end
end