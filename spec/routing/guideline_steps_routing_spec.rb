require "spec_helper"

describe GuidelineStepsController do
  describe "routing" do

    it "routes to #index" do
      get("/guideline_steps").should route_to("guideline_steps#index")
    end

    it "routes to #new" do
      get("/guideline_steps/new").should route_to("guideline_steps#new")
    end

    it "routes to #show" do
      get("/guideline_steps/1").should route_to("guideline_steps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/guideline_steps/1/edit").should route_to("guideline_steps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/guideline_steps").should route_to("guideline_steps#create")
    end

    it "routes to #update" do
      put("/guideline_steps/1").should route_to("guideline_steps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/guideline_steps/1").should route_to("guideline_steps#destroy", :id => "1")
    end

  end
end
