# Have Mini Profiler show up on the right
if defined? Rack::MiniProfiler
	Rack::MiniProfiler.config.position = 'right'
end