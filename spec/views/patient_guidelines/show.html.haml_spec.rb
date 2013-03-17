require 'spec_helper'

describe "patient_guidelines/show" do
  before(:each) do
    @patient_guideline = assign(:patient_guideline, stub_model(PatientGuideline,
      :guideline_id => 1,
      :patient_id => 2,
      :status => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
