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

  version :normal do
    process resize_to_fill: [200,200]
  end

  version :thumb, :from_version => :normal do
    process resize_to_fill: [50, 50]
  end

  def extension_white_list
    %w(jpg jpeg gif png bmp tif tiff)
  end

  def filename
    "#{model.artists.map{|a| a.name}.join('-')}_#{model.title}_#{Date.today.strftime "%Y%m%d" }.jpg".gsub(/[^0-9A-Za-z_\-\.]+/, '') if original_filename
  end

end
