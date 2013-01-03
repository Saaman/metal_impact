require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Import::SourceFile" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:source_file) { FactoryGirl.create(:source_file) }

  context "when is anonymous user" do
    let(:user) { User.new }
    it{ should_not be_able_to(:create, source_file) }
    it{ should_not be_able_to(:read, source_file) }
    it{ should_not be_able_to(:destroy, source_file) }
    it{ should_not be_able_to(:update, source_file) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }
    it{ should_not be_able_to(:create, source_file) }
    it{ should_not be_able_to(:read, source_file) }
    it{ should_not be_able_to(:destroy, source_file) }
    it{ should_not be_able_to(:update, source_file) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }
    it{ should_not be_able_to(:create, source_file) }
    it{ should_not be_able_to(:read, source_file) }
    it{ should_not be_able_to(:destroy, source_file) }
    it{ should_not be_able_to(:update, source_file) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:create, source_file) }
    it{ should be_able_to(:read, source_file) }
    it{ should be_able_to(:destroy, source_file) }
    it{ should be_able_to(:update, source_file) }
  end
end