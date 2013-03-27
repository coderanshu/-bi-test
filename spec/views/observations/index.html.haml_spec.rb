require 'spec_helper'

describe "observations/index" do
  before(:each) do
    assign(:observations, [
      stub_model(Observation),
      stub_model(Observation)
    ])
  end

  it "renders a list of observations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
