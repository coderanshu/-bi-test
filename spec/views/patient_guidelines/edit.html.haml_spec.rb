require 'spec_helper'

describe "patient_guidelines/edit" do
  before(:each) do
    @patient_guideline = assign(:patient_guideline, stub_model(PatientGuideline,
      :guideline_id => 1,
      :patient_id => 1,
      :status => 1
    ))
  end

  it "renders the edit patient_guideline form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", patient_guideline_path(@patient_guideline), "post" do
      assert_select "input#patient_guideline_guideline_id[name=?]", "patient_guideline[guideline_id]"
      assert_select "input#patient_guideline_patient_id[name=?]", "patient_guideline[patient_id]"
      assert_select "input#patient_guideline_status[name=?]", "patient_guideline[status]"
    end
  end
end
