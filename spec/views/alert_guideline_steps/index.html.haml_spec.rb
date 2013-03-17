require 'spec_helper'

describe "alert_guideline_steps/index" do
  before(:each) do
    assign(:alert_guideline_steps, [
      stub_model(AlertGuidelineStep,
        :alert_id => 1,
        :patient_guideline_step_id => 2
      ),
      stub_model(AlertGuidelineStep,
        :alert_id => 1,
        :patient_guideline_step_id => 2
      )
    ])
  end

  it "renders a list of alert_guideline_steps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
