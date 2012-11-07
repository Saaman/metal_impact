require 'spec_helper'
require 'carrierwave/test/matchers'

describe CoverUploader do
  include CarrierWave::Test::Matchers

  let!(:album) { FactoryGirl.create(:album_with_artists) }

  it "should not allow to save other files than images" do
    #CoverUploader.enable_processing = true
    @uploader = CoverUploader.new(album, :cover)
    expect { @uploader.store! File.open(File.join([uploaders_fixtures_path, 'fake_img.php'])) }.to raise_error
  end

  it "can't upload an image smaller than 5Kb" do
    #CoverUploader.enable_processing = true
    #@uploader = CoverUploader.new(album, :cover)
    album.cover = File.open(File.join([uploaders_fixtures_path, 'too_small.gif']))
    album.should_not be_valid
  end

  describe "processing tests" do
    before do
      CoverUploader.enable_processing = true
      @uploader = CoverUploader.new(album, :cover)
      @uploader.store! File.open(File.join([uploaders_fixtures_path, 'test_img.png']))
    end

    after do
      CoverUploader.enable_processing = false
      @uploader.remove!
    end

    context 'the thumb version' do
      it "should scale down an image to be no larger than 666 by 666 pixels" do
        @uploader.should be_no_larger_than(666, 666)
      end
    end

    context 'the thumb version' do
      it "should scale down a landscape image to be exactly 200 by 200 pixels" do
        @uploader.normal.should have_dimensions(200, 200)
      end
    end

    context 'the small version' do
      it "should scale down a landscape image to be exactly 50 by 50 pixels" do
        #@uploader.small_thumb.should be_no_larger_than(50, 50)
        @uploader.thumb.should have_dimensions(50, 50)
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
end