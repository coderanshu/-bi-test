require "spec_helper"

describe PatientGuidelineStepsController do
  describe "routing" do

    it "routes to #index" do
      get("/patient_guideline_steps").should route_to("patient_guideline_steps#index")
    end

    it "routes to #new" do
      get("/patient_guideline_steps/new").should route_to("patient_guideline_steps#new")
    end

    it "routes to #show" do
      get("/patient_guideline_steps/1").should route_to("patient_guideline_steps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/patient_guideline_steps/1/edit").should route_to("patient_guideline_steps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/patient_guideline_steps").should route_to("patient_guideline_steps#create")
    end

    it "routes to #update" do
      put("/patient_guideline_steps/1").should route_to("patient_guideline_steps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/patient_guideline_steps/1").should route_to("patient_guideline_steps#destroy", :id => "1")
    end

  end
end
