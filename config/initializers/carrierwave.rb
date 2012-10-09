CarrierWave.configure do |config|
	if Rails.env.test?
    #set up local files storage for testing
    config.storage = :file
	  config.enable_processing = false
  else
    #these 2 lines are to make carrierwave work on Heroku
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'carrierwave'

    config.storage = :fog
    config.fog_credentials = {
      :provider                         => 'Google',
      :google_storage_access_key_id     => ENV['GOOGLE_STORAGE_API_KEY'],
      :google_storage_secret_access_key => ENV['GOOGLE_STORAGE_API_SECRET']
    }
    config.fog_directory = 'metalimpact'
  end
end

#This a monkey patch to make the version to be added as a suffix of the filename
module CarrierWave
  module Uploader
    module Versions
      def full_filename(for_file)
        parent_name = super(for_file)
        ext         = File.extname(parent_name)
        base_name   = parent_name.chomp(ext)
        [base_name, version_name].compact.join('_') + ext
      end

      def full_original_filename
        parent_name = super
        ext         = File.extname(parent_name)
        base_name   = parent_name.chomp(ext)
        [base_name, version_name].compact.join('_') + ext
      end
    end
  end
end