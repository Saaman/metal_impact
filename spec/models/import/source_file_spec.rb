# == Schema Information
#
# Table name: import_source_files
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  source     :string(255)      not null
#  status_cd  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Import::SourceFile do
  before do
    @source_file = Import::SourceFile.new name: "import1", status: :complete, source: "metal_impact"
  end

  subject { @source_file }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:status) }
    it { should respond_to(:source) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #methods
    it { should respond_to(:import_not_started?) }
    it { should respond_to(:import_not_started!) }
    it { should respond_to(:import_in_progress?) }
    it { should respond_to(:import_in_progress!) }
    it { should respond_to(:import_partial?) }
    it { should respond_to(:import_partial!) }
    it { should respond_to(:import_complete?) }
    it { should respond_to(:import_complete!) }
    it { should respond_to(:import_has_errors?) }
    it { should respond_to(:import_has_errors!) }
  end

  describe "Validations" do
  	it { should be_valid }

    describe "when name" do
      describe "is not present" do
        before { @source_file.name = " " }
        it { should_not be_valid }
      end
    end
    describe "when source" do
      describe "is not present" do
        before { @source_file.source = " " }
        it { should_not be_valid }
      end
    end
  end

  describe "Callbacks" do
  	describe "it titleize source when saving" do
  		before { @source_file.save }
  		its(:source) { should == "Metal Impact" }
  	end
    describe "it set status to :not_started when empty" do
      before do
        @source_file.status = nil
        @source_file.valid?
      end
      its(:status) { should == :not_started }
    end
  end

end
