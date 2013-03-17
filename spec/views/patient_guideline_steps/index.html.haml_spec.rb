require 'spec_helper'

describe "patient_guideline_steps/index" do
  before(:each) do
    assign(:patient_guideline_steps, [
      stub_model(PatientGuidelineStep,
        :patient_guideline_id => 1,
        :guideline_step_id => 2,
        :is_met => false,
        :requires_data => false,
        :status => 3
      ),
      stub_model(PatientGuidelineStep,
        :patient_guideline_id => 1,
        :guideline_step_id => 2,
        :is_met => false,
        :requires_data => false,
        :status => 3
      )
    ])
  end

  it "renders a list of patient_guideline_steps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
