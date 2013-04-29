require 'cancan/matchers'
require 'spec_helper'

describe "authorizations on Review" do
  subject { ability }
  let(:ability) { Ability.new(user) }
  let(:unpublished_review) { FactoryGirl.create(:review, published: false) }
  let(:review) { FactoryGirl.create(:review, :published) }

  context "when is anonymous user" do
    let(:user) { User.new }

    it{ should_not be_able_to(:create, unpublished_review) }
    it{ should_not be_able_to(:read, unpublished_review) }
    it{ should_not be_able_to(:update, unpublished_review) }

    it{ should_not be_able_to(:create, review) }
    it{ should be_able_to(:read, review) }
    it{ should_not be_able_to(:update, review) }
    it{ should_not be_able_to(:bypass_contribution, review) }
  end

  context "when is basic user" do
    let(:user) { FactoryGirl.create(:user) }

    it{ should_not be_able_to(:create, unpublished_review) }
    it{ should_not be_able_to(:read, unpublished_review) }
    it{ should_not be_able_to(:update, unpublished_review) }

    it{ should_not be_able_to(:create, review) }
    it{ should be_able_to(:read, review) }
    it{ should_not be_able_to(:update, review) }
    it{ should_not be_able_to(:bypass_contribution, review) }
  end

  context "when is staff user" do
    let(:user) { FactoryGirl.create(:user, :role => :staff) }

    it{ should be_able_to(:create, unpublished_review) }
    it{ should_not be_able_to(:read, unpublished_review) }
    it{ should_not be_able_to(:update, unpublished_review) }

    it{ should be_able_to(:create, review) }
    it{ should be_able_to(:read, review) }
    it{ should be_able_to(:update, review) }
    it{ should_not be_able_to(:bypass_contribution, review) }

    describe "can read unpublished review for which he is the last updater" do
      before do
        unpublished_review.activity :owner => user
        unpublished_review.save!
      end
      it{ should be_able_to(:create, unpublished_review) }
      it{ should be_able_to(:read, unpublished_review) }
      it{ should be_able_to(:update, unpublished_review) }
    end
  end

  context "when is admin user" do
    let(:user) { FactoryGirl.create(:user, :role => :admin) }

    it{ should be_able_to(:create, unpublished_review) }
    it{ should be_able_to(:read, unpublished_review) }
    it{ should be_able_to(:update, unpublished_review) }

    it{ should be_able_to(:create, review) }
    it{ should be_able_to(:read, review) }
    it{ should be_able_to(:update, review) }
    it{ should be_able_to(:bypass_contribution, review) }
  end
end
