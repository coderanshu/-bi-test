require "spec_helper"

describe ValueSetsController do
  describe "routing" do

    it "routes to #index" do
      get("/value_sets").should route_to("value_sets#index")
    end

    it "routes to #new" do
      get("/value_sets/new").should route_to("value_sets#new")
    end

    it "routes to #show" do
      get("/value_sets/1").should route_to("value_sets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/value_sets/1/edit").should route_to("value_sets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/value_sets").should route_to("value_sets#create")
    end

    it "routes to #update" do
      put("/value_sets/1").should route_to("value_sets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/value_sets/1").should route_to("value_sets#destroy", :id => "1")
    end

  end
end
