require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on User" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:other_user) { FactoryGirl.create(:user) }

  context "when is anonymous user" do
    let(:user) { User.new }

    it { should be_able_to(:create, User.new) }
    it { should be_able_to(:create, user) }
    it { should be_able_to(:read, user) }
    it { should_not be_able_to(:read, other_user) }
    it { should_not be_able_to(:destroy, other_user) }
    it { should_not be_able_to(:destroy, user) }
    it { should_not be_able_to(:update, other_user) }
    it { should_not be_able_to(:update, user) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }

    it { should_not be_able_to(:create, User.new) }
    it { should_not be_able_to(:create, user) }
    it { should be_able_to(:read, user) }
    it { should_not be_able_to(:read, other_user) }
    it { should_not be_able_to(:destroy, other_user) }
    it { should be_able_to(:destroy, user) }
    it { should_not be_able_to(:update, other_user) }
    it { should be_able_to(:update, user) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }

    it { should_not be_able_to(:create, User.new) }
    it { should_not be_able_to(:create, user) }
    it { should be_able_to(:read, user) }
    it { should_not be_able_to(:read, other_user) }
    it { should_not be_able_to(:destroy, other_user) }
    it { should_not be_able_to(:destroy, user) }
    it { should_not be_able_to(:update, other_user) }
    it { should be_able_to(:update, user) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it { should_not be_able_to(:create, User.new) }
    it { should_not be_able_to(:create, user) }
    it { should be_able_to(:read, user) }
    it { should be_able_to(:read, other_user) }
    it { should be_able_to(:destroy, other_user) }
    it { should_not be_able_to(:destroy, user) }
    it { should be_able_to(:update, other_user) }
    it { should be_able_to(:update, user) }
  end
end