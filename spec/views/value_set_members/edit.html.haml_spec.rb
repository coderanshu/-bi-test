require 'spec_helper'

describe "value_set_members/edit" do
  before(:each) do
    @value_set_member = assign(:value_set_member, stub_model(ValueSetMember,
      :code => "MyString",
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit value_set_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", value_set_member_path(@value_set_member), "post" do
      assert_select "input#value_set_member_code[name=?]", "value_set_member[code]"
      assert_select "input#value_set_member_name[name=?]", "value_set_member[name]"
      assert_select "input#value_set_member_description[name=?]", "value_set_member[description]"
    end
  end
end
