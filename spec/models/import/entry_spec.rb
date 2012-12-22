# == Schema Information
#
# Table name: import_entries
#
#  id                    :integer          not null, primary key
#  target_model_cd       :integer
#  source_id             :integer
#  target_id             :integer
#  import_source_file_id :integer
#  data                  :text             not null
#  state                 :string(255)      default("new"), not null
#  error                 :string(255)
#  type                  :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'


describe Import::Entry do
  let(:source_file) { FactoryGirl.create(:source_file) }
  before do
    @entry = Import::Entry.new data: {'toto' => 1, :essai => "tata"}, source_file: source_file
  end

  subject { @entry }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:data) }
    it { should respond_to(:error) }
    it { should respond_to(:source_id) }
    it { should respond_to(:target_id) }
    it { should respond_to(:target_model) }
    it { should respond_to(:source_file) }
    it { should_not respond_to(:source_file_id) }

    #methods
    it { should respond_to(:auto_discover) }
    it { should respond_to(:can_auto_discover?) }
  end

  describe "Validations" do
  	it { should be_valid }

    describe "when data is not present" do
      before { @entry.data = " " }
      it { should_not be_valid }
    end

    describe "when source_file is not present" do
      before { @entry.source_file = nil }
      it { should_not be_valid }
    end
  end

  describe "State Machine" do
    it "it can auto-discover when state is :new" do
      @entry.can_auto_discover?.should be_true
    end
  end
end
