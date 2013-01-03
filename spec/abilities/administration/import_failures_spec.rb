require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Import::Failure" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:failure) { FactoryGirl.create(:failure) }

  context "when is anonymous user" do
    let(:user) { User.new }
    it{ should_not be_able_to(:create, failure) }
    it{ should_not be_able_to(:read, failure) }
    it{ should_not be_able_to(:destroy, failure) }
    it{ should_not be_able_to(:update, failure) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }
    it{ should_not be_able_to(:create, failure) }
    it{ should_not be_able_to(:read, failure) }
    it{ should_not be_able_to(:destroy, failure) }
    it{ should_not be_able_to(:update, failure) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }
    it{ should_not be_able_to(:create, failure) }
    it{ should_not be_able_to(:read, failure) }
    it{ should_not be_able_to(:destroy, failure) }
    it{ should_not be_able_to(:update, failure) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:create, failure) }
    it{ should be_able_to(:read, failure) }
    it{ should be_able_to(:destroy, failure) }
    it{ should be_able_to(:update, failure) }
  end
end