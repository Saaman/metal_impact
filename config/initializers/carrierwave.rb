CarrierWave.configure do |config|
	if Rails.env.test?
	  config.storage = :file
	  config.enable_processing = false
	end

	config.permissions = 0664
  #config.directory_permissions = 0771
end