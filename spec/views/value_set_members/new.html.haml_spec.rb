require 'spec_helper'

describe "value_set_members/new" do
  before(:each) do
    assign(:value_set_member, stub_model(ValueSetMember,
      :code => "MyString",
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new value_set_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", value_set_members_path, "post" do
      assert_select "input#value_set_member_code[name=?]", "value_set_member[code]"
      assert_select "input#value_set_member_name[name=?]", "value_set_member[name]"
      assert_select "input#value_set_member_description[name=?]", "value_set_member[description]"
    end
  end
end
