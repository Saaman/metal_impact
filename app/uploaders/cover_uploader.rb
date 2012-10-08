class CoverUploader < CarrierWave::Uploader::Base

  # Include MiniMagick support:
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  def store_dir
    "#{mounted_as}s/#{model.class.to_s.underscore}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :resize_to_limit => [500, 500] do |img|
    img.format 'jpg'
  end

  version :thumb do
    process :resize_to_fill => [100,100]
  end

  version :small_thumb, :from_version => :thumb do
    process resize_to_fill: [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end

  def filename
    "#{model.artists.map{|a| a.name}.join('-').gsub(/\s+/, '')}_#{model.title.gsub(/\s+/, '')}.jpg" if original_filename
  end

end
