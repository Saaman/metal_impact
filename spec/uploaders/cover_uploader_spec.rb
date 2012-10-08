require 'spec_helper'
require 'carrierwave/test/matchers'

describe CoverUploader do
  include CarrierWave::Test::Matchers

  let!(:album) { FactoryGirl.create(:album_with_artists) }

  it "should not allow to save other files than images" do
    CoverUploader.enable_processing = true
    @uploader = CoverUploader.new(album, :cover)
    expect { @uploader.store! File.open(File.join([uploaders_fixtures_path, 'fake_img.php'])) }.to raise_error
  end

  before do
    CoverUploader.enable_processing = true
    @uploader = CoverUploader.new(album, :cover)
    @uploader.store! File.open(File.join([uploaders_fixtures_path, 'test_img.gif']))
  end

  after do
    CoverUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the thumb version' do
    it "should scale down a landscape image to be exactly 100 by 100 pixels" do
      @uploader.thumb.should have_dimensions(100, 100)
    end
  end

  context 'the small version' do
    it "should scale down a landscape image to be exactly 50 by 50 pixels" do
      #@uploader.small_thumb.should be_no_larger_than(50, 50)
      @uploader.small_thumb.should have_dimensions(50, 50)
    end
  end

  it "should be named after artist names & album title" do
    expected_file_name = "#{album.artists.map{|a| a.name}.join('-').gsub(/\s+/, '')}_#{album.title.gsub(/\s+/, '')}"
    @uploader.current_path.should include expected_file_name
  end

  it "should be stored as a jpg" do
    @uploader.current_path.should include '.jpg'
  end
end