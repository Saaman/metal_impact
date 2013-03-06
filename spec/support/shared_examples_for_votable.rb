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