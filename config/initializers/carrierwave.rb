CarrierWave.configure do |config|
	if Rails.env.test?
	  config.storage = :file
	  config.enable_processing = false
	end

	config.permissions = 0664
  #config.directory_permissions = 0771

  config.fog_credentials = {
    :provider                         => 'Google',
    :google_storage_access_key_id     => 'GOOGK2RDVAHAQFSPV7XU',
    :google_storage_secret_access_key => 'XaD3Mvb6HCXVe+qAPljIQJdlIpt3pgatQLAW1Irk'
  }
  config.fog_directory = 'metalimpact'
end