require 'spec_helper'

describe "patient_guideline_steps/edit" do
  before(:each) do
    @patient_guideline_step = assign(:patient_guideline_step, stub_model(PatientGuidelineStep,
      :patient_guideline_id => 1,
      :guideline_step_id => 1,
      :is_met => false,
      :requires_data => false,
      :status => 1
    ))
  end

  it "renders the edit patient_guideline_step form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", patient_guideline_step_path(@patient_guideline_step), "post" do
      assert_select "input#patient_guideline_step_patient_guideline_id[name=?]", "patient_guideline_step[patient_guideline_id]"
      assert_select "input#patient_guideline_step_guideline_step_id[name=?]", "patient_guideline_step[guideline_step_id]"
      assert_select "input#patient_guideline_step_is_met[name=?]", "patient_guideline_step[is_met]"
      assert_select "input#patient_guideline_step_requires_data[name=?]", "patient_guideline_step[requires_data]"
      assert_select "input#patient_guideline_step_status[name=?]", "patient_guideline_step[status]"
    end
  end
end
