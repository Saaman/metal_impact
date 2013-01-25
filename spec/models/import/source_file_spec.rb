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
  before  { @source_file = FactoryGirl.build(:source_file) }
  subject { @source_file }

  describe "attributes and methods" do
    #attributes
    it { should respond_to(:path) }
    it { should respond_to(:state) }
    it { should respond_to(:state_name) }
    it { should respond_to(:source_type) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should respond_to(:entries) }
    it { should respond_to(:entry_ids) }
    it { should respond_to(:failures) }
    it { should respond_to(:failure_ids) }

    #methods
    it { should respond_to(:name) }
    it { should respond_to(:is_of_type_metal_impact?) }
    it { should respond_to(:is_of_type_metal_impact!) }
    it { should respond_to(:entries_count) }
    it { should respond_to(:has_failures?) }
    it { should respond_to(:can_set_source_type?) }
    it { should respond_to(:set_source_type_and_load_entries) }
    it { should respond_to(:stats) }
    it { should respond_to(:entries_types_counts) }
    it { should respond_to(:overall_progress) }
    it { should respond_to(:pending_progress) }
    it { should respond_to(:prepare) }
    it { should respond_to(:import) }
    it { should respond_to(:auto_refresh) }
    it { should respond_to(:failed_entries_count) }

    #transitions
    it { should respond_to(:new?) }
    it { should respond_to(:load_file) }
    it { should respond_to(:can_load_file?) }
    it { should respond_to(:loaded?) }
    it { should respond_to(:unload_file) }
    it { should respond_to(:can_unload_file?) }
    it { should respond_to(:preparing_entries?) }
    it { should respond_to(:async_prepare) }
    it { should respond_to(:can_async_prepare?) }
    it { should respond_to(:prepared?) }
    it { should respond_to(:async_import) }
    it { should respond_to(:can_async_import?) }
    it { should respond_to(:importing_entries?) }
    it { should respond_to(:refresh_status) }
    it { should respond_to(:can_refresh_status?) }
    it { should respond_to(:imported?) }
  end

  describe "Validations :" do
  	it { should be_valid }

    describe "when path" do
      describe "is not present" do
        before { @source_file.path = " " }
        it { should_not be_valid }
      end
    end

    describe "when source_type" do
      describe "is not present" do
        before { @source_file.source_type = nil }
        it { should be_valid }
      end
      describe "is not present for update" do
        before do
          @source_file.save!
          @source_file.source_type = nil
        end
        it { should_not be_valid }
      end
    end
  end

  describe "Behaviors :" do
    describe "it set status to new on initializing" do
      its(:state_name) { should == :new }
    end
    describe 'Path is read-only' do
      let(:sf) { FactoryGirl.create(:source_file) }
      it 'must not be alterable' do
        sf.path = "toto"
        sf.source_type = :metal_impact
        @source_file.save
        @source_file.reload.path.should_not == "toto"
      end
    end
  end

  describe "Helpers :" do
    describe "Name should return the file name" do
      before { @source_file.path = File.join([Rails.root, "toto.yml"]) }
      its(:name) { should == "toto.yml" }
    end
    describe "has_failures?" do
      its(:has_failures?) { should be_false }
      describe "is true when failures associated" do
        let(:source_file) { FactoryGirl.create(:source_file, :with_failed_entries) }
        specify { source_file.has_failures?.should be_true }
      end
    end
    describe "can_set_source_type?" do
      it "should be true when state is new or loaded" do
        @source_file.can_set_source_type?.should be_true
        @source_file.state = 'loaded'
        @source_file.can_set_source_type?.should be_true
        @source_file.state = 'prepared'
        @source_file.can_set_source_type?.should be_false
      end
    end
    describe "auto_refresh" do
      it "should be true when state is pending" do
        @source_file.auto_refresh.should be_false
        @source_file.state = 'preparing_entries'
        @source_file.auto_refresh.should be_true
        @source_file.state = 'preparing_entries'
        @source_file.auto_refresh.should be_true
      end
    end
  end

  describe "Stats calculation :" do
    # describe "stats" do
    #   let(:source_file) { FactoryGirl.create(:source_file, :with_entries, :source_type => :metal_impact) }
    #   let(:prepared_entry) { FactoryGirl.create(:entry, :discovered, state: 'prepared') }
    #   let(:artist_entry) { FactoryGirl.create(:entry, :discovered, state: 'prepared') }
    #   before do
    #     source_file.entries << prepared_entry
    #     source_file.entries << artist_entry
    #     source_file.save!
    #   end
    #   it "should count entries per state" do
    #     entries_count = source_file.entries.size
    #     source_file.stats.should == {"new" => entries_count-1, "prepared" => 1}
    #   end
    #   it "should count entries per model" do
    #     entries_count = source_file.entries.size
    #     source_file.entries_types_counts.should == {0 => entries_count-1, 1 => 1}
    #   end
    # end
    describe "failed_entries_count" do
      let(:source_file) { FactoryGirl.create :source_file, :with_failed_entries }
      it "should count failures" do
        source_file.failed_entries_count.should == source_file.entries.size
      end
    end
    describe "entries_count" do
      let(:source_file) { FactoryGirl.create :source_file, :with_entries }
      it "should count entries" do
        source_file.entries_count.should == source_file.entries.size
      end
      it "should use stats to perform the calculation" do
        source_file.should_receive(:stats).and_return({'new' => 5})
        source_file.entries_count
      end
    end
    describe "*_progress" do
      let(:source_file) { FactoryGirl.create :source_file }
      it 'when not entries associated' do
        source_file.overall_progress.should == 0
        source_file.pending_progress.should == 0
      end
      context 'when entries associated' do
        before { source_file.stub(:stats).and_return({'new' => 10, 'prepared' => 7, 'flagged' => 4, 'imported' => 1}) }
        it 'overall_progress use stats to compute overall progress' do
          source_file.overall_progress.should == 18
        end
        it 'pending_progress counts entries in preparation' do
          source_file.should_receive(:preparing_entries?).and_return(true)
          source_file.pending_progress.should == 9
        end
        it 'pending_progress counts flagged entries' do
          source_file.pending_progress.should == 12
        end
      end
    end
  end

  describe "State Machine" do
    describe 'load_file' do
      let(:source_file) { FactoryGirl.create :source_file, :ready }
      it "can prepare entries only if source_type is set" do
        @source_file.can_load_file?.should be_false
        source_file.can_load_file?.should be_true
      end
      it 'should call load_entries' do
        source_file.should_receive(:load_entries).and_return(true)
        source_file.load_file
      end
    end
    describe 'unload_file' do
      let(:source_file) { FactoryGirl.create :source_file, :ready, :with_entries, state: 'loaded' }
      it 'should remove all entries' do
        source_file.can_unload_file?.should be_true
        @source_file.can_unload_file?.should be_false
        source_file.unload_file.should be_true
        source_file.entries.size.should == 0
        source_file.should be_new
      end
    end

    describe 'set_source_type_and_load_entries' do
      let(:source_file) { FactoryGirl.create :source_file }
      let(:loaded_source_file) { FactoryGirl.create :source_file, :ready, :with_entries, state: 'loaded' }
      it 'should update source_type and load file' do
        source_file.should_receive(:load_file)
        source_file.should_not_receive(:unload_file!)
        source_file.set_source_type_and_load_entries :metal_impact
        source_file.source_type.should == :metal_impact
      end
      it 'should unload file if already loaded' do
        loaded_source_file.should_receive(:load_file)
        loaded_source_file.should_receive(:unload_file!)
        loaded_source_file.set_source_type_and_load_entries :metal_impact
      end
    end

    describe 'async_prepare' do
      describe 'when source_file has failures' do
        let(:source_file) { FactoryGirl.create :source_file, :ready, :with_failed_entries, state: 'loaded' }
        it 'is forbidden' do
          source_file.can_async_prepare?.should be_false
          @source_file.can_async_prepare?.should be_false
        end
      end
      describe 'when source_file is loaded' do
        let(:source_file) { FactoryGirl.create :source_file, :ready, :with_entries, state: 'loaded' }
        it 'is allowed' do
          source_file.can_async_prepare?.should be_true
        end
        it 'should prepare entries' do
          Import::Entry.any_instance.stub(:auto_discover).and_return(true)
          source_file.async_prepare.should be_true
          source_file.should be_preparing_entries
        end
      end
    end
    describe 'async_import' do
      describe 'when source_file has failures' do
        let(:source_file) { FactoryGirl.create :source_file, :ready, :with_failed_entries, state: 'prepared' }
        it 'is forbidden' do
          source_file.can_async_import?.should be_false
          @source_file.can_async_import?.should be_false
        end
      end
      describe 'when source_file is prepared' do
        let(:source_file) { FactoryGirl.create :source_file, :ready, :with_discovered_entries, state: 'prepared' }
        it 'is allowed' do
          source_file.can_async_import?.should be_true
        end
        it 'should import entries' do
          Import::Entry.any_instance.stub(:async_import).and_return(true)
          source_file.async_import.should be_true
          source_file.should be_importing_entries
        end
      end
    end
    describe "refresh_status" do
      let(:pre_source_file) { FactoryGirl.create(:source_file, :with_discovered_entries, :ready, :state => 'preparing_entries') }
      let(:failed_source_file) { FactoryGirl.create(:source_file, :with_failed_entries, :ready, :state => 'preparing_entries') }
      let(:imp_source_file) { FactoryGirl.create(:source_file, :ready, :state => 'importing_entries') }
      it "can do the transition any time" do
        pre_source_file.can_refresh_status?.should be_true
        failed_source_file.can_refresh_status?.should be_true
        imp_source_file.can_refresh_status?.should be_true
        @source_file.can_refresh_status?.should be_true
      end
      it "transit from preparing_entries to prepared" do
        pre_source_file.refresh_status
        pre_source_file.should be_prepared
      end
       it "transit from preparing_entries to loaded" do
        failed_source_file.refresh_status
        failed_source_file.should be_loaded
      end
      it "transit from importing_entries to imported" do
        imp_source_file.stub(:stats).and_return({"imported" => 5})
        imp_source_file.refresh_status
        imp_source_file.should be_imported
      end
      it "transit from importing_entries to prepared" do
        imp_source_file.stub(:stats).and_return({"imported" => 2, "prepared" => 3})
        imp_source_file.refresh_status
        imp_source_file.should be_prepared
      end
      it "transit from importing_entries to importing_entries" do
        imp_source_file.stub(:stats).and_return({'imported' => 2, 'prepared' => 2, 'flagged' => 1})
        imp_source_file.refresh_status
        imp_source_file.should be_importing_entries
      end
    end
  end
end