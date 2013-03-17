require 'spec_helper'

describe "patient_guidelines/new" do
  before(:each) do
    assign(:patient_guideline, stub_model(PatientGuideline,
      :guideline_id => 1,
      :patient_id => 1,
      :status => 1
    ).as_new_record)
  end

  it "renders new patient_guideline form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", patient_guidelines_path, "post" do
      assert_select "input#patient_guideline_guideline_id[name=?]", "patient_guideline[guideline_id]"
      assert_select "input#patient_guideline_patient_id[name=?]", "patient_guideline[patient_id]"
      assert_select "input#patient_guideline_status[name=?]", "patient_guideline[status]"
    end
  end
end
