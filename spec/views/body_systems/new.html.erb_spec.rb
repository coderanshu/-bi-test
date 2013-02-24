require 'spec_helper'

describe "body_systems/new" do
  before(:each) do
    assign(:body_system, stub_model(BodySystem,
      :name => "MyString",
      :order => 1
    ).as_new_record)
  end

  it "renders new body_system form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", body_systems_path, "post" do
      assert_select "input#body_system_name[name=?]", "body_system[name]"
      assert_select "input#body_system_order[name=?]", "body_system[order]"
    end
  end
end
