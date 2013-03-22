require 'spec_helper'

describe "value_sets/show" do
  before(:each) do
    @value_set = assign(:value_set, stub_model(ValueSet,
      :code => "Code",
      :code_system => "Code System",
      :name => "Name",
      :description => "Description",
      :source => "Source"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code/)
    rendered.should match(/Code System/)
    rendered.should match(/Name/)
    rendered.should match(/Description/)
    rendered.should match(/Source/)
  end
end
