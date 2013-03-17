require 'spec_helper'

describe "patient_guidelines/index" do
  before(:each) do
    assign(:patient_guidelines, [
      stub_model(PatientGuideline,
        :guideline_id => 1,
        :patient_id => 2,
        :status => 3
      ),
      stub_model(PatientGuideline,
        :guideline_id => 1,
        :patient_id => 2,
        :status => 3
      )
    ])
  end

  it "renders a list of patient_guidelines" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
