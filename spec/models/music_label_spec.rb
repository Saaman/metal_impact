# == Schema Information
#
# Table name: music_labels
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  website     :string(255)
#  distributor :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'spec_helper'

describe MusicLabel do
  before { @musicLabel = MusicLabel.new(name: "Relapse Records", website: "http://www.google.com") }
  
  subject { @musicLabel }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:website) }
    it { should respond_to(:distributor) }
    it { should respond_to(:albums) }
  end

  describe "Validations" do

    it { should be_valid }

    describe "when name is not present" do
      before { @musicLabel.name = " " }
      it { should_not be_valid }
    end

    describe "when name is already taken" do
      before do
        label_with_same_name = @musicLabel.dup
        label_with_same_name.name = @musicLabel.name.upcase
        label_with_same_name.save
      end
      it { should_not be_valid }
    end

    describe "when website format is invalid" do
      invalid_websites =  %w[tata http:example.fr http://example.fr. http//example http://example]
      invalid_websites.each do |invalid_website|
        before { @musicLabel.website = invalid_website }
        it { should_not be_valid }
      end
    end

    describe "when website format is valid" do
      valid_websites = %w[http://example.fr.com https://fr.example.com http://example.fr]
      valid_websites.each do |valid_website|
        before { @musicLabel.website = valid_website }
        it { should be_valid }
      end
    end

    describe "when website is already taken" do
      before do
        label_with_same_website = @musicLabel.dup
        label_with_same_website.website = @musicLabel.website.upcase
        label_with_same_website.save
      end
      it { should_not be_valid }
    end
  end
end
