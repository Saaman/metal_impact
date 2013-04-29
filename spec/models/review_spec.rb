# == Schema Information
#
# Table name: reviews
#
#  id           :integer          not null, primary key
#  product_id   :integer
#  product_type :string(255)
#  score        :integer
#  reviewer_id  :integer
#  published    :boolean          default(FALSE), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Review do
  before do
    @review = FactoryGirl.build :review
  end

  subject { @review }

  it_should_behave_like "contributable model" do
    let(:contributable) { @review }
  end

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:body, :product, :score, :reviewer, :product_id, :product_type) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe "Validations" do

    it { should be_valid }

    describe "when body" do
      describe "is not present" do
        before { @review.body = " " }
        it { should_not be_valid }
      end
    end
    describe "when product" do
      describe "is not present" do
        before { @review.product = nil }
        it { should_not be_valid }
      end
      describe "has no valid id" do
        before { @review.product_id = @review.product.id + 1000 }
        it { should_not be_valid }
      end
    end
    describe "when reviewer" do
      describe "is not present" do
        before { @review.reviewer = nil }
        it { should_not be_valid }
      end
    end
    describe "when score" do
      describe "is not present" do
        before { @review.score = nil }
        it { should_not be_valid }
      end
      describe "is not a number" do
        before { @review.score = 'toto' }
        it { should_not be_valid }
      end
      describe "is negative" do
        before { @review.score = -1 }
        it { should_not be_valid }
      end
      describe "is grater than 10" do
        before { @review.score = 11 }
        it { should_not be_valid }
      end
      describe "is not a integer" do
        before { @review.score = 5.8 }
        it { should_not be_valid }
      end
    end
  end
end
