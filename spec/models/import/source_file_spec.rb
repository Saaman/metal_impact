# == Schema Information
#
# Table name: import_source_files
#
#  id             :integer          not null, primary key
#  path           :string(255)      not null
#  source_type_cd :integer
#  state          :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Import::SourceFile do
  let(:source_file) { FactoryGirl.create(:source_file) }
  before do
    @source_file = source_file
  end

  subject { @source_file }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:state) }
    it { should respond_to(:source_type) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should respond_to(:entries) }
    it { should respond_to(:entry_ids) }
    it { should respond_to(:failures) }
    it { should respond_to(:failure_ids) }
    it { should respond_to(:entries_count) }

    #methods
    it { should respond_to(:is_of_type_metal_impact?) }
    it { should respond_to(:is_of_type_metal_impact!) }
    it { should respond_to(:load_file) }
    it { should respond_to(:can_load_file?) }
    it { should respond_to(:start_preparing) }
    it { should respond_to(:can_start_preparing?) }
    it { should respond_to(:refresh_status) }
    it { should respond_to(:can_refresh_status?) }
  end

  describe "Validations" do
  	it { should be_valid }

    describe "when path" do
      describe "is not present" do
        before { @source_file.path = " " }
        it { should_not be_valid }
      end
    end
  end

  describe "Callbacks" do
    describe "it set status to new on initializing" do
      its(:state_name) { should == :new }
    end
  end

  describe "Methods" do
    describe "Name should return the file name" do
      before { @source_file.path = File.join([Rails.root, "toto.yml"]) }
      its(:name) { should == "toto.yml" }
    end
  end


  describe "State Machine" do
    it "it can prepare entries only if source_type is set" do
      @source_file.can_load_file?.should be_false
      @source_file.is_of_type_metal_impact!
      @source_file.can_load_file?.should be_true
    end
  end

end
