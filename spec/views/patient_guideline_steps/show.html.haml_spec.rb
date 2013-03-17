require 'spec_helper'

describe "patient_guideline_steps/show" do
  before(:each) do
    @patient_guideline_step = assign(:patient_guideline_step, stub_model(PatientGuidelineStep,
      :patient_guideline_id => 1,
      :guideline_step_id => 2,
      :is_met => false,
      :requires_data => false,
      :status => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/3/)
  end
end
