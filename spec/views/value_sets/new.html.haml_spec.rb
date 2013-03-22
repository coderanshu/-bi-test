require 'spec_helper'

describe "value_sets/new" do
  before(:each) do
    assign(:value_set, stub_model(ValueSet,
      :code => "MyString",
      :code_system => "MyString",
      :name => "MyString",
      :description => "MyString",
      :source => "MyString"
    ).as_new_record)
  end

  it "renders new value_set form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", value_sets_path, "post" do
      assert_select "input#value_set_code[name=?]", "value_set[code]"
      assert_select "input#value_set_code_system[name=?]", "value_set[code_system]"
      assert_select "input#value_set_name[name=?]", "value_set[name]"
      assert_select "input#value_set_description[name=?]", "value_set[description]"
      assert_select "input#value_set_source[name=?]", "value_set[source]"
    end
  end
end
