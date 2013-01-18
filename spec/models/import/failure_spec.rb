# == Schema Information
#
# Table name: import_failures
#
#  id              :integer          not null, primary key
#  description     :text             not null
#  import_entry_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe Import::Failure do
  let(:entry) { FactoryGirl.create(:entry) }
  before do
    @failure = Import::Failure.new description: "this is an error", entry: entry
  end

  subject { @failure }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:description) }
    it { should_not respond_to(:entry_id) }
    it { should respond_to(:entry) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #methods
  end

  describe "Validations" do
  	it { should be_valid }

    describe "when description is not present" do
      before { @failure.description = " " }
      it { should_not be_valid }
    end

    describe "when entry is not present" do
      before { @failure.entry = nil }
      it { should_not be_valid }
    end
  end
end
