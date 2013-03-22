require "spec_helper"

describe ValueSetMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/value_set_members").should route_to("value_set_members#index")
    end

    it "routes to #new" do
      get("/value_set_members/new").should route_to("value_set_members#new")
    end

    it "routes to #show" do
      get("/value_set_members/1").should route_to("value_set_members#show", :id => "1")
    end

    it "routes to #edit" do
      get("/value_set_members/1/edit").should route_to("value_set_members#edit", :id => "1")
    end

    it "routes to #create" do
      post("/value_set_members").should route_to("value_set_members#create")
    end

    it "routes to #update" do
      put("/value_set_members/1").should route_to("value_set_members#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/value_set_members/1").should route_to("value_set_members#destroy", :id => "1")
    end

  end
end
