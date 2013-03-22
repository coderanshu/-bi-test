require 'spec_helper'

describe "value_sets/index" do
  before(:each) do
    assign(:value_sets, [
      stub_model(ValueSet,
        :code => "Code",
        :code_system => "Code System",
        :name => "Name",
        :description => "Description",
        :source => "Source"
      ),
      stub_model(ValueSet,
        :code => "Code",
        :code_system => "Code System",
        :name => "Name",
        :description => "Description",
        :source => "Source"
      )
    ])
  end

  it "renders a list of value_sets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Code System".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "Source".to_s, :count => 2
  end
end
