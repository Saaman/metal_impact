require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Home" do
  subject { ability }
  let(:ability){ Ability.new(user) }

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