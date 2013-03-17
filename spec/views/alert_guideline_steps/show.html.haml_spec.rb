require 'spec_helper'

describe "alert_guideline_steps/show" do
  before(:each) do
    @alert_guideline_step = assign(:alert_guideline_step, stub_model(AlertGuidelineStep,
      :alert_id => 1,
      :patient_guideline_step_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
