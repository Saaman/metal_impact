require 'cancan/matchers'
require 'spec_helper'

describe 'other authorizations' do
  subject { ability }
  let(:ability){ Ability.new(user) }

  describe "authorizations on Home" do
    context "when is anonymous user" do
      let(:user) { User.new }
      it{ should be_able_to(:read, :home) }
      it{ should_not be_able_to(:show_image, :home) }
    end

    context "when is basic user" do
      let(:user) { FactoryGirl.create(:user) }
      it{ should be_able_to(:read, :home) }
      it{ should be_able_to(:show_image, :home) }
    end
  end

  describe "authorizations on Monitoring" do
    context "when is anonymous user" do
      let(:user) { User.new }
      it{ should_not be_able_to(:dashboard, :monitoring) }
    end
    context "when is basic user" do
      let(:user) { FactoryGirl.create(:user) }
      it{ should_not be_able_to(:dashboard, :monitoring) }
    end
    context "when is staff user" do
      let(:user) { FactoryGirl.create(:user, role: :staff) }
      it{ should_not be_able_to(:dashboard, :monitoring) }
    end
    context "when is admin user" do
      let(:user) { FactoryGirl.create(:user, role: :admin) }
      it{ should be_able_to(:dashboard, :monitoring) }
    end
  end

end