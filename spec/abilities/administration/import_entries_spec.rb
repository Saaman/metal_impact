require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Import::Entry" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:entry) { FactoryGirl.create(:entry) }

  context "when is anonymous user" do
    let(:user) { User.new }
    it{ should_not be_able_to(:create, entry) }
    it{ should_not be_able_to(:read, entry) }
    it{ should_not be_able_to(:destroy, entry) }
    it{ should_not be_able_to(:update, entry) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }
    it{ should_not be_able_to(:create, entry) }
    it{ should_not be_able_to(:read, entry) }
    it{ should_not be_able_to(:destroy, entry) }
    it{ should_not be_able_to(:update, entry) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }
    it{ should_not be_able_to(:create, entry) }
    it{ should_not be_able_to(:read, entry) }
    it{ should_not be_able_to(:destroy, entry) }
    it{ should_not be_able_to(:update, entry) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:create, entry) }
    it{ should be_able_to(:read, entry) }
    it{ should be_able_to(:destroy, entry) }
    it{ should be_able_to(:update, entry) }
  end
end