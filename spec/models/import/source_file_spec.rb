# == Schema Information
#
# Table name: import_source_files
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  source        :string(255)      not null
#  sha1_checksum :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Import::SourceFile do
  before do
    @source_file = Import::SourceFile.new name: "import1", sha1_checksum: Digest::SHA1.hexdigest('toto'), source: "metal_impact"
  end

  subject { @source_file }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:name) }
    it { should respond_to(:sha1_checksum) }
    it { should respond_to(:source) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }

    #methods
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
    describe "when sha1_checksum" do
      describe "is not present" do
        before { @source_file.sha1_checksum = " " }
        it { should_not be_valid }
      end
      describe "is too long" do
        before { @source_file.sha1_checksum = "a"*41 }
        it { should_not be_valid }
      end
      describe "is too short" do
        before { @source_file.sha1_checksum = "a"*39 }
        it { should_not be_valid }
      end
    end
  end

  describe "Callbacks" do
  	describe "it titleize source when saving" do
  		before { @source_file.save }
  		its(:source) { should == "Metal Impact" }
  	end
  end

  describe "Initializing" do
  	it "should raise exception if source file path is empty" do
  		expect{ Import::SourceFile.init_from_file }.to raise_error(ArgumentError)
  	end
  end

end
