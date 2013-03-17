require 'spec_helper'

describe "guideline_steps/show" do
  before(:each) do
    @guideline_step = assign(:guideline_step, stub_model(GuidelineStep,
      :name => "Name",
      :description => "Description",
      :order => 1,
      :guideline_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
