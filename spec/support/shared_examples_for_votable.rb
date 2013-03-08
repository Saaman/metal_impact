require "rspec/expectations"
require "set"

shared_examples "routes for vote" do
	it "routes to #upvote" do
    put("/#{resources}/1/upvote").should route_to("#{resources}#upvote", :id => "1")
  end

  it "routes to #downvote" do
    put("/#{resources}/1/downvote").should route_to("#{resources}#downvote", :id => "1")
  end
end

shared_examples 'votable model' do
	describe "attributes and methods :" do
    #attributes
    it { should respond_to(:votes_ratio) }

    #methods
    it { should respond_to(:vote) }
    it { should respond_to(:json_presenter) }
  end

  it 'votes_ratio should calculate ratio of positive votes' do
    votable.stub(:cached_votes_total) { 4 }
    votable.stub(:cached_votes_up) { 3 }
    votable.votes_ratio.should == 75
  end

  it 'votes_ratio should render a hash with values to put on screen' do
    votable.stub(:cached_votes_total) { 4 }
    votable.stub(:cached_votes_up) { 3 }
    votable.stub(:cached_votes_down) { 1 }

    votable.json_presenter[:votes_up].should == 3
    votable.json_presenter[:votes_down].should == 1
    votable.json_presenter[:votes_ratio].should == 75
  end
end

shared_examples 'votable controller' do
  stub_abilities
  let(:voter) { FactoryGirl.create :user }

  describe "PUT upvote :" do
    describe "(unauthorized)" do
      before { put :upvote, id: votable.id }
      its_access_is "unauthorized"
    end

    describe "(authorized)" do
      before(:each) { @ability.can :upvote, votable.class }
      before { @controller.stub(:current_user) { voter } }
      it "should upvote" do
        put :upvote, id: votable.id, :format => :json
        assigns(:votable).should == votable
        votable.reload.cached_votes_up.should == 1
        votable.reload.cached_votes_total.should == 1
      end
      it 'should not register an activity' do
        expect { put :upvote, id: votable.id, :format => :json }.to_not change{PublicActivity::Activity.count}
      end
    end
  end

  describe "PUT downvote :" do
    describe "(unauthorized)" do
      before  { put :downvote, id: votable.id }
      its_access_is "unauthorized"
    end

    describe "(authorized)" do
      before(:each) { @ability.can :downvote, votable.class }
      before { @controller.stub(:current_user) { voter } }
      it "should downvote" do
        put :downvote, id: votable.id, :format => :json
        assigns(:votable).should == votable
        votable.reload.cached_votes_down.should == 1
      end
    end
  end
end
