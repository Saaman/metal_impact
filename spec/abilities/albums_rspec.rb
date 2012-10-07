require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Album" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:unpublished_album) { FactoryGirl.create(:album_with_artists) }
  let(:album) { FactoryGirl.create(:album_with_artists, published: true) }

  context "when is anonymous user" do
    let(:user) { User.new }

    it{ should_not be_able_to(:create, album) }
    it{ should be_able_to(:read, album) }
    it{ should_not be_able_to(:read, unpublished_album) }
    it{ should_not be_able_to(:destroy, album) }
    it{ should_not be_able_to(:update, album) }
    it{ should_not be_able_to(:bypass_approval, album) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }

    it{ should_not be_able_to(:create, album) }
    it{ should be_able_to(:read, album) }
    it{ should_not be_able_to(:read, unpublished_album) }
    it{ should_not be_able_to(:destroy, album) }
    it{ should_not be_able_to(:update, album) }
    it{ should_not be_able_to(:bypass_approval, album) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }

    it{ should be_able_to(:create, album) }
    it{ should be_able_to(:read, album) }
    it{ should_not be_able_to(:read, unpublished_album) }
    describe "can read unpublished album for which he is the last updater" do
      before { unpublished_album.updater_id = user.id }
      it{ should be_able_to(:read, unpublished_album) }
    end
    it{ should be_able_to(:destroy, album) }
    it{ should be_able_to(:update, album) }
    it{ should_not be_able_to(:bypass_approval, album) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:create, album) }
    it{ should be_able_to(:read, album) }
    it{ should be_able_to(:destroy, album) }
    it{ should be_able_to(:update, album) }
    it{ should be_able_to(:bypass_approval, album) }
  end
end