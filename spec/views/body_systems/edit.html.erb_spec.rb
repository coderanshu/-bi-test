require 'spec_helper'

describe "body_systems/edit" do
  before(:each) do
    @body_system = assign(:body_system, stub_model(BodySystem,
      :name => "MyString",
      :order => 1
    ))
  end

  it "renders the edit body_system form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", body_system_path(@body_system), "post" do
      assert_select "input#body_system_name[name=?]", "body_system[name]"
      assert_select "input#body_system_order[name=?]", "body_system[order]"
    end
  end
end
