require 'spec_helper'

describe "guidelines/show" do
  before(:each) do
    @guideline = assign(:guideline, stub_model(Guideline,
      :name => "Name",
      :organization => "Organization",
      :url => "Url",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Organization/)
    rendered.should match(/Url/)
    rendered.should match(/Description/)
  end
end
