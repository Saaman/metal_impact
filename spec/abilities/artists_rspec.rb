require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Artist" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:artist) { FactoryGirl.create(:artist) }

  context "when is anonymous user" do
    let(:user) { User.new }

    it{ should_not be_able_to(:create, artist) }
    it{ should be_able_to(:read, artist) }
    it{ should_not be_able_to(:destroy, artist) }
    it{ should_not be_able_to(:update, artist) }
    it{ should_not be_able_to(:search, artist) }
    it{ should_not be_able_to(:smallblock, artist) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create (:user) }

    it{ should_not be_able_to(:create, artist) }
    it{ should be_able_to(:read, artist) }
    it{ should_not be_able_to(:destroy, artist) }
    it{ should_not be_able_to(:update, artist) }
    it{ should be_able_to(:search, artist) }
    it{ should be_able_to(:smallblock, artist) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create (:admin) }

    it{ should be_able_to(:create, artist) }
    it{ should be_able_to(:read, artist) }
    it{ should be_able_to(:destroy, artist) }
    it{ should be_able_to(:update, artist) }
    it{ should be_able_to(:search, artist) }
    it{ should be_able_to(:smallblock, artist) }
  end
end