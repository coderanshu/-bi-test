require 'spec_helper'

describe "PatientGuidelineSteps" do
  describe "GET /patient_guideline_steps" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get patient_guideline_steps_path
      response.status.should be(200)
    end
  end
end
