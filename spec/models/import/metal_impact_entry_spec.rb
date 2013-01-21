require 'spec_helper'


describe Import::MetalImpactEntry do
  let(:metal_impact_entry) { FactoryGirl.create(:metal_impact_entry) }

  subject { metal_impact_entry }

  describe "attributes and methods" do

    #methods
    it { should respond_to(:discover) }
    it { should respond_to(:import_as_user) }
    it { should respond_to(:import_as_artist) }
  end

  describe "Methods :" do
    describe "discover" do
      it "add an error if data is not a hash" do
        metal_impact_entry.data = "toto"
        metal_impact_entry.discover
        metal_impact_entry.should_not be_valid
      end
      it "add an error if data[:model] is not a valid target_model" do
        metal_impact_entry.data = {id: 2, model: "toto"}
        metal_impact_entry.discover
        metal_impact_entry.should_not be_valid
      end
      it "save source_id and target_model" do
        metal_impact_entry.discover
        metal_impact_entry.should be_valid
        metal_impact_entry.reload.source_id.should_not be_nil
        metal_impact_entry.reload.target_model.should_not be_nil
      end
    end
    describe 'import_as_user' do
      let(:entry) { FactoryGirl.create(:discovered_metal_impact_user) }
      it 'should create a new user' do
        expect { entry.import_as_user }.to change{User.count}.by(1)
      end
      it 'should override timestamps' do
        entry.data[:updated_at] = (DateTime.now - 5.days).to_s
        entry.import_as_user
        User.last.updated_at.should == entry.data[:updated_at]
      end
      it 'should confirm the user' do
        entry.import_as_user
        User.last.should be_confirmed
      end
      it 'should not create a user when data is not valid' do
        entry.data[:email] = "toto"
        expect { entry.import_as_user }.not_to change{User.count}
      end
      it 'should update entry with target_id' do
        entry.import_as_user
        entry.reload.target_id.should_not be_nil
      end
      it "should not update entry when target model can't be saved" do
        entry.data[:email] = "toto"
        entry.import_as_user
        entry.errors.size.should > 0
        entry.reload.target_id.should be_nil
      end
    end
  end

  describe "Dependencies management :" do
    let(:entry) { FactoryGirl.create(:discovered_metal_impact_artist) }
    let(:dependency) { FactoryGirl.create(:discovered_metal_impact_user) }
    let(:user) { FactoryGirl.create(:user) }
    before do
      def entry.temp_dependencies
        dependencies
      end
      def entry.temp_do_import
        do_import
      end
      dependency.target_id = user.id
      dependency.source_file = entry.source_file
      dependency.save!
    end
    it 'should retrieve the existing dependency' do
      dependency.target_model.should == :user
      dependency.source_id.should == 2
      dependency.import_source_file_id.should == entry.import_source_file_id

      entry.temp_do_import
      entry.temp_dependencies.should == {:reviewer_id => 1}
    end
    it 'should raise if source_id is not correct' do
      entry.data[:created_by] = -1
      entry.save!

      expect { entry.temp_do_import }.to raise_error(ArgumentError, /source/)
    end
    it 'should raise if no matching dependency is found' do
      dependency.source_id = 48
      dependency.save!

      expect { entry.temp_do_import }.to raise_error(/no entry/)
    end

    context "when dependency is not yet imported" do
      before do
        dependency.target_id = nil
        dependency.save!
      end
      it 'should raise ImportDependency exception if entry import is in progress' do
        Import::Entry.any_instance.should_receive(:flagged?) { true }
        expect { entry.temp_do_import }.to raise_error(Exceptions::ImportDependencyException)
      end
      it 'should raise ImportDependency exception and start import if entry is not imported yet' do
        Import::Entry.any_instance.should_receive(:flagged?) { false }
        Import::Entry.any_instance.should_receive(:async_import) { true }
        expect { entry.temp_do_import }.to raise_error(Exceptions::ImportDependencyException)
      end
      it "should raise exception if dependency import can't start" do
        Import::Entry.any_instance.should_receive(:flagged?) { false }
        Import::Entry.any_instance.should_receive(:async_import) { false }
        expect { entry.temp_do_import }.to raise_error(/Impossible to start/)
      end
    end
  end
end