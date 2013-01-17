Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 25
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 10
Delayed::Worker.delay_jobs = !Rails.env.test?

#DJ_Mon configuration
MetalImpact::Application.config.dj_mon.username = ENV['DJMON_USER']
MetalImpact::Application.config.dj_mon.password = ENV['DJMON_PWD']