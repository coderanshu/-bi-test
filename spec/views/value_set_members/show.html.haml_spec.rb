require 'spec_helper'

describe "value_set_members/show" do
  before(:each) do
    @value_set_member = assign(:value_set_member, stub_model(ValueSetMember,
      :code => "Code",
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Code/)
    rendered.should match(/Name/)
    rendered.should match(/Description/)
  end
end
