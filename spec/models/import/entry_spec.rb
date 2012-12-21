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


    # describe "on update" do
    #   before { @entry.save! }
    #   describe "when previous_status is not present" do
    #     before { @entry.previous_status = nil }
    #     it { should_not be_valid }
    #   end
    # end
  end

  # describe "Callbacks" do
  #   describe "it set status to :new when empty" do
  #     before do
  #       @entry.status = nil
  #       @entry.valid?
  #     end
  #     its(:status) { should == :new }
  #   end
  # end

  # describe "Life cycle enforcement" do
  #   before { @entry.save! }
  #   describe "should refuse invalid statuses changes" do
  #     it_behaves_like "a status change", :new, :new, false
  #   end
  # end
end
