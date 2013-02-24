require "spec_helper"

describe BodySystemsController do
  describe "routing" do

    it "routes to #index" do
      get("/body_systems").should route_to("body_systems#index")
    end

    it "routes to #new" do
      get("/body_systems/new").should route_to("body_systems#new")
    end

    it "routes to #show" do
      get("/body_systems/1").should route_to("body_systems#show", :id => "1")
    end

    it "routes to #edit" do
      get("/body_systems/1/edit").should route_to("body_systems#edit", :id => "1")
    end

    it "routes to #create" do
      post("/body_systems").should route_to("body_systems#create")
    end

    it "routes to #update" do
      put("/body_systems/1").should route_to("body_systems#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/body_systems/1").should route_to("body_systems#destroy", :id => "1")
    end

  end
end
