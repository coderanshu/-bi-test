require 'spec_helper'

describe "patients/index" do
  before(:each) do
    assign(:patients, [
      stub_model(Patient,
        :source_mrn => "Source Mrn",
        :prefix => "Prefix",
        :first_name => "First Name",
        :middle_name => "Middle Name",
        :last_name => "Last Name",
        :suffix => "Suffix"
      ),
      stub_model(Patient,
        :source_mrn => "Source Mrn",
        :prefix => "Prefix",
        :first_name => "First Name",
        :middle_name => "Middle Name",
        :last_name => "Last Name",
        :suffix => "Suffix"
      )
    ])
  end

  it "renders a list of patients" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Source Mrn".to_s, :count => 2
    assert_select "tr>td", :text => "Prefix".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Middle Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Suffix".to_s, :count => 2
  end
end
