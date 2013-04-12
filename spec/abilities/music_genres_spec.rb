require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on MusicGenre" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:music_genre) { FactoryGirl.create :music_genre }

  context "when is anonymous user" do
    let(:user) { User.new }

    it{ should be_able_to(:search, music_genre) }
    it{ should_not be_able_to(:bypass_contribution, music_genre) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }

    it{ should be_able_to(:search, music_genre) }
    it{ should_not be_able_to(:bypass_contribution, music_genre) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }

    it{ should be_able_to(:search, music_genre) }
    it{ should_not be_able_to(:bypass_contribution, music_genre) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:search, music_genre) }
    it{ should be_able_to(:bypass_contribution, music_genre) }
  end
end
