require 'spec_helper'

describe "alert_guideline_steps/new" do
  before(:each) do
    assign(:alert_guideline_step, stub_model(AlertGuidelineStep,
      :alert_id => 1,
      :patient_guideline_step_id => 1
    ).as_new_record)
  end

  it "renders new alert_guideline_step form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", alert_guideline_steps_path, "post" do
      assert_select "input#alert_guideline_step_alert_id[name=?]", "alert_guideline_step[alert_id]"
      assert_select "input#alert_guideline_step_patient_guideline_step_id[name=?]", "alert_guideline_step[patient_guideline_step_id]"
    end
  end
end
