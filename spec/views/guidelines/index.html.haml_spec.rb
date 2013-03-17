require 'spec_helper'

describe "guidelines/index" do
  before(:each) do
    assign(:guidelines, [
      stub_model(Guideline,
        :name => "Name",
        :organization => "Organization",
        :url => "Url",
        :description => "Description"
      ),
      stub_model(Guideline,
        :name => "Name",
        :organization => "Organization",
        :url => "Url",
        :description => "Description"
      )
    ])
  end

  it "renders a list of guidelines" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Organization".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
