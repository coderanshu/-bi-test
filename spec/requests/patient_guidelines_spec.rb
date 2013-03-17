require 'spec_helper'

describe "PatientGuidelines" do
  describe "GET /patient_guidelines" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get patient_guidelines_path
      response.status.should be(200)
    end
  end
end
