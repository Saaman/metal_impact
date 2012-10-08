CarrierWave.configure do |config|
	if Rails.env.test?
    #set up local files storage for testing
    config.storage = :file
	  config.enable_processing = false
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider                         => 'Google',
      :google_storage_access_key_id     => ENV['GOOGLE_STORAGE_API_KEY'],
      :google_storage_secret_access_key => ENV['GOOGLE_STORAGE_API_SECRET']
    }
    config.fog_directory = 'metalimpact'
  end
end