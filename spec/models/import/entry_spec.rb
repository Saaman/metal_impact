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
    it { should respond_to(:source_id) }
    it { should respond_to(:target_id) }
    it { should respond_to(:target_model) }
    it { should respond_to(:target_model_cd) }
    it { should respond_to(:source_file) }
    it { should_not respond_to(:source_file_id) }
    it { should respond_to(:failures) }
    it { should respond_to(:failure_ids) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #transitions
    it { should respond_to(:auto_discover) }
    it { should respond_to(:can_auto_discover?) }
    it { should respond_to(:import) }
    it { should respond_to(:can_import?) }
    it { should respond_to(:refresh_status) }
    it { should respond_to(:can_refresh_status?) }
    it { should respond_to(:async_import) }
    it { should respond_to(:can_async_import?) }
  end

  describe "Validations :" do
  	it { should be_valid }

    describe "when data is not present" do
      before { @entry.data = " " }
      it { should_not be_valid }
    end

    describe "when source_file is not present" do
      before { @entry.source_file = nil }
      it { should_not be_valid }
    end

    describe "when source_file is not present" do
      before { @entry.source_file = nil }
      it { should_not be_valid }
    end

    describe "target_model is required for update" do
      before do
        @entry.save!
        @entry.target_model = " "
      end
      it { should_not be_valid }
    end
  end

  describe "Behaviors :" do
    describe "it set status to new on initializing" do
      its(:state_name) { should == :new }
    end
  end

  describe "Scopes :" do
    let(:entry) { FactoryGirl.create(:entry) }
    let(:user_entry) { FactoryGirl.create(:entry, :target_model => :user) }
    let(:prepared_entry) { FactoryGirl.create(:entry, :discovered, :state => :prepared) }
    describe "of_type" do
      it 'should filter on target_model' do
        Import::Entry.of_type(:user).should_not be_include(entry)
        Import::Entry.of_type(:user).should be_include(user_entry)
        Import::Entry.of_type(:user).should be_include(prepared_entry)
      end
    end
    describe "at_state" do
      it 'should filter on state' do
        Import::Entry.at_state(:prepared).should_not be_include(entry)
        Import::Entry.at_state(:prepared).should_not be_include(user_entry)
        Import::Entry.at_state(:prepared).should be_include(prepared_entry)
      end
    end
  end

  describe "State Machine :" do
    it "it can auto-discover when state is :new" do
      @entry.can_auto_discover?.should be_true
    end
    describe "async import" do
      let(:prepared_entry) { FactoryGirl.create(:entry, :discovered, :state => :prepared) }
      it "can happen when entry is prepared" do
        prepared_entry.can_async_import?.should be_true
        @entry.can_async_import?.should be_false
      end
      it "perform the transition" do
        prepared_entry.should_receive(:do_import) { true }
        prepared_entry.async_import
        prepared_entry.should be_flagged
      end
    end
    describe "import" do
      let(:flagged_entry) { FactoryGirl.create(:entry, :discovered, :state => :flagged) }
      it "can happen when entry is flagged" do
        flagged_entry.can_import?.should be_true
        @entry.can_import?.should be_false
      end
      it "perform the transition" do
        flagged_entry.should_receive("import_as_#{flagged_entry.target_model}") { true }
        flagged_entry.import
        flagged_entry.should be_imported
      end
    end
    describe "refresh_status" do
      let(:flagged_entry) { FactoryGirl.create(:entry, :discovered, :state => :flagged) }
      let(:imported_entry) { FactoryGirl.create(:entry, :discovered, :state => :imported) }
      it "can happen when entry is flagged or imported" do
        flagged_entry.can_refresh_status?.should be_true
        imported_entry.can_refresh_status?.should be_true
        @entry.can_refresh_status?.should be_false
      end
      it "transit from flagged to prepared" do
        flagged_entry.refresh_status
        flagged_entry.should be_prepared
      end
      it "transit from imported to imported" do
        imported_entry.refresh_status
        imported_entry.should be_imported
      end
    end
  end
end