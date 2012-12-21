# == Schema Information
#
# Table name: import_source_files
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  source_type_cd :integer
#  state          :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'spec_helper'

describe Import::SourceFile do
  before do
    @source_file = Import::SourceFile.new name: "import1"
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

    #methods
    it { should respond_to(:is_of_type_metal_impact?) }
    it { should respond_to(:is_of_type_metal_impact!) }
  end

  describe "Validations" do
  	it { should be_valid }

    describe "when name" do
      describe "is not present" do
        before { @source_file.name = " " }
        it { should_not be_valid }
      end
    end
  end

  describe "Callbacks" do
    describe "it set status to new on initializing" do
      its(:state_name) { should == :new }
    end
  end

  describe "State Machine" do
    it "it can discover entries only if source_type is set" do
      @source_file.can_discover_entries?.should be_false
      @source_file.is_of_type_metal_impact!
      @source_file.can_discover_entries?.should be_true
    end
  end

end
