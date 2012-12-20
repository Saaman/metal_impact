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
#  status_cd             :integer
#  previous_status_cd    :integer
#  error                 :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require 'spec_helper'


shared_examples "a status change" do |status, previous_status, validation_result|
  before do
    @entry.status = status
    @entry.previous_status = previous_status
  end
  it "should match validation" do
    @entry.save.should == validation_result
  end
end

describe Import::Entry do
  before do
    @entry = Import::Entry.new data: {'toto' => 1, :essai => "tata"}
  end

  subject { @entry }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:data) }
    it { should respond_to(:error) }
    it { should respond_to(:source_id) }
    it { should respond_to(:target_id) }
    it { should respond_to(:target_model) }
    #it { should respond_to(:status) }
    #it { should respond_to(:previous_status) }

    #methods
    # it { should respond_to(:entry_new?) }
    # it { should respond_to(:entry_new!) }
    # it { should respond_to(:entry_ready?) }
    # it { should respond_to(:entry_ready!) }
    # it { should respond_to(:entry_pre_processed?) }
    # it { should respond_to(:entry_pre_processed!) }
    # it { should respond_to(:entry_imported?) }
    # it { should respond_to(:entry_imported!) }
    # it { should respond_to(:entry_processed?) }
    # it { should respond_to(:entry_processed!) }
    # it { should respond_to(:entry_in_error?) }
    # it { should respond_to(:entry_in_error!) }
    # it { should respond_to(:entry_in_treatment?) }
    # it { should respond_to(:entry_in_treatment!) }
    # it { should respond_to(:entry_waiting?) }
    # it { should respond_to(:entry_waiting!) }

    # it { should respond_to(:entry_was_new?) }
    # it { should respond_to(:entry_was_new!) }
    # it { should respond_to(:entry_was_ready?) }
    # it { should respond_to(:entry_was_ready!) }
    # it { should respond_to(:entry_was_pre_processed?) }
    # it { should respond_to(:entry_was_pre_processed!) }
    # it { should respond_to(:entry_was_imported?) }
    # it { should respond_to(:entry_was_imported!) }
    # it { should respond_to(:entry_was_processed?) }
    # it { should respond_to(:entry_was_processed!) }
    # it { should respond_to(:entry_was_in_error?) }
    # it { should respond_to(:entry_was_in_error!) }
    # it { should respond_to(:status=) }
    # it { should_not respond_to(:previous_status=) }
  end

  describe "Validations" do
  	it { should be_valid }

    describe "on creation :" do
      describe "when data is not present" do
        before { @entry.data = " " }
        it { should_not be_valid }
      end
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
