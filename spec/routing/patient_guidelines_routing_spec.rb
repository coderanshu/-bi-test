require "spec_helper"

describe PatientGuidelinesController do
  describe "routing" do

    it "routes to #index" do
      get("/patient_guidelines").should route_to("patient_guidelines#index")
    end

    it "routes to #new" do
      get("/patient_guidelines/new").should route_to("patient_guidelines#new")
    end

    it "routes to #show" do
      get("/patient_guidelines/1").should route_to("patient_guidelines#show", :id => "1")
    end

    it "routes to #edit" do
      get("/patient_guidelines/1/edit").should route_to("patient_guidelines#edit", :id => "1")
    end

    it "routes to #create" do
      post("/patient_guidelines").should route_to("patient_guidelines#create")
    end

    it "routes to #update" do
      put("/patient_guidelines/1").should route_to("patient_guidelines#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/patient_guidelines/1").should route_to("patient_guidelines#destroy", :id => "1")
    end

  end
end
