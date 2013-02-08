require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Contributions" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:contribution) { Contribution.new object: FactoryGirl.create(:artist) }

  context "when is anonymous user" do
    let(:user) { User.new }
    it{ should_not be_able_to(:create, contribution) }
    it{ should_not be_able_to(:read, contribution) }
    it{ should_not be_able_to(:destroy, contribution) }
    it{ should_not be_able_to(:update, contribution) }
    it{ should_not be_able_to(:approve, contribution) }
    it{ should_not be_able_to(:refuse, contribution) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }
    it{ should_not be_able_to(:create, contribution) }
    it{ should_not be_able_to(:read, contribution) }
    it{ should_not be_able_to(:destroy, contribution) }
    it{ should_not be_able_to(:update, contribution) }
    it{ should_not be_able_to(:approve, contribution) }
    it{ should_not be_able_to(:refuse, contribution) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }
    it{ should_not be_able_to(:create, contribution) }
    it{ should_not be_able_to(:read, contribution) }
    it{ should_not be_able_to(:destroy, contribution) }
    it{ should_not be_able_to(:update, contribution) }
    it{ should_not be_able_to(:approve, contribution) }
    it{ should_not be_able_to(:refuse, contribution) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:create, contribution) }
    it{ should be_able_to(:read, contribution) }
    it{ should be_able_to(:destroy, contribution) }
    it{ should be_able_to(:update, contribution) }
    it{ should be_able_to(:approve, contribution) }
    it{ should be_able_to(:refuse, contribution) }
  end
end