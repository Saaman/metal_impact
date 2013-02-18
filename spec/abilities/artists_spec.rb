require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Artist" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:artist) { FactoryGirl.create(:artist) }
  let(:unpublished_artist) { FactoryGirl.create(:artist, published: false) }

  context "when is anonymous user" do
    let(:user) { User.new }
    it{ should_not be_able_to(:create, unpublished_artist) }
    it{ should_not be_able_to(:read, unpublished_artist) }
    it{ should_not be_able_to(:destroy, unpublished_artist) }
    it{ should_not be_able_to(:update, unpublished_artist) }

    it{ should_not be_able_to(:create, artist) }
    it{ should be_able_to(:read, artist) }
    it{ should_not be_able_to(:destroy, artist) }
    it{ should_not be_able_to(:update, artist) }
    it{ should be_able_to(:search, artist) }
    it{ should be_able_to(:smallblock, artist) }
    it{ should_not be_able_to(:bypass_contribution, artist) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }
    it{ should_not be_able_to(:create, unpublished_artist) }
    it{ should_not be_able_to(:read, unpublished_artist) }
    it{ should_not be_able_to(:destroy, unpublished_artist) }
    it{ should_not be_able_to(:update, unpublished_artist) }

    it{ should_not be_able_to(:create, artist) }
    it{ should be_able_to(:read, artist) }
    it{ should_not be_able_to(:destroy, artist) }
    it{ should_not be_able_to(:update, artist) }
    it{ should be_able_to(:search, artist) }
    it{ should be_able_to(:smallblock, artist) }
    it{ should_not be_able_to(:bypass_contribution, artist) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }
    it{ should be_able_to(:create, unpublished_artist) }
    it{ should_not be_able_to(:read, unpublished_artist) }
    it{ should_not be_able_to(:destroy, unpublished_artist) }
    it{ should_not be_able_to(:update, unpublished_artist) }

    it{ should be_able_to(:create, artist) }
    it{ should be_able_to(:read, artist) }
    it{ should_not be_able_to(:destroy, artist) }
    it{ should be_able_to(:update, artist) }
    it{ should be_able_to(:search, artist) }
    it{ should be_able_to(:smallblock, artist) }
    it{ should_not be_able_to(:bypass_contribution, artist) }

    describe "can read unpublished album for which he is the last updater" do
      before do
        unpublished_artist.activity :owner => user
        unpublished_artist.save!
      end
      it{ should be_able_to(:read, unpublished_artist) }
      it{ should_not be_able_to(:destroy, unpublished_artist) }
      it{ should be_able_to(:update, unpublished_artist) }
    end
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:create, unpublished_artist) }
    it{ should be_able_to(:read, unpublished_artist) }
    it{ should be_able_to(:destroy, unpublished_artist) }
    it{ should be_able_to(:update, unpublished_artist) }

    it{ should be_able_to(:create, artist) }
    it{ should be_able_to(:read, artist) }
    it{ should be_able_to(:destroy, artist) }
    it{ should be_able_to(:update, artist) }
    it{ should be_able_to(:search, artist) }
    it{ should be_able_to(:smallblock, artist) }
    it{ should be_able_to(:bypass_contribution, artist) }
  end
end