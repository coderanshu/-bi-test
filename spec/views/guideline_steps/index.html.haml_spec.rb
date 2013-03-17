require 'spec_helper'

describe "guideline_steps/index" do
  before(:each) do
    assign(:guideline_steps, [
      stub_model(GuidelineStep,
        :name => "Name",
        :description => "Description",
        :order => 1,
        :guideline_id => 2
      ),
      stub_model(GuidelineStep,
        :name => "Name",
        :description => "Description",
        :order => 1,
        :guideline_id => 2
      )
    ])
  end

  it "renders a list of guideline_steps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
