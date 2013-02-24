require 'spec_helper'

describe "body_systems/show" do
  before(:each) do
    @body_system = assign(:body_system, stub_model(BodySystem,
      :name => "Name",
      :order => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
  end
end
