require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on MusicLabel" do
  subject { ability }
  let(:ability){ Ability.new(user) }
  let(:music_label) { FactoryGirl.create(:music_label) }

  context "when is anonymous user" do
    let(:user) { User.new }

    it{ should_not be_able_to(:create, music_label) }
    it{ should be_able_to(:read, music_label) }
    it{ should_not be_able_to(:destroy, music_label) }
    it{ should_not be_able_to(:update, music_label) }
    it{ should_not be_able_to(:smallblock, music_label) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create (:user) }

    it{ should_not be_able_to(:create, music_label) }
    it{ should be_able_to(:read, music_label) }
    it{ should_not be_able_to(:destroy, music_label) }
    it{ should_not be_able_to(:update, music_label) }
    it{ should be_able_to(:smallblock, music_label) }
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create (:admin) }

    it{ should be_able_to(:create, music_label) }
    it{ should be_able_to(:read, music_label) }
    it{ should be_able_to(:destroy, music_label) }
    it{ should be_able_to(:update, music_label) }
    it{ should be_able_to(:smallblock, music_label) }
  end
end