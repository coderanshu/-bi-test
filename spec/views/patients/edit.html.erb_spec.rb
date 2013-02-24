require 'spec_helper'

describe "patients/edit" do
  before(:each) do
    @patient = assign(:patient, stub_model(Patient,
      :source_mrn => "MyString",
      :prefix => "MyString",
      :first_name => "MyString",
      :middle_name => "MyString",
      :last_name => "MyString",
      :suffix => "MyString"
    ))
  end

  it "renders the edit patient form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", patient_path(@patient), "post" do
      assert_select "input#patient_source_mrn[name=?]", "patient[source_mrn]"
      assert_select "input#patient_prefix[name=?]", "patient[prefix]"
      assert_select "input#patient_first_name[name=?]", "patient[first_name]"
      assert_select "input#patient_middle_name[name=?]", "patient[middle_name]"
      assert_select "input#patient_last_name[name=?]", "patient[last_name]"
      assert_select "input#patient_suffix[name=?]", "patient[suffix]"
    end
  end
end
