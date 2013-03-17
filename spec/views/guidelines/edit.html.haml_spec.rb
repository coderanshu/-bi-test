require 'spec_helper'

describe "guidelines/edit" do
  before(:each) do
    @guideline = assign(:guideline, stub_model(Guideline,
      :name => "MyString",
      :organization => "MyString",
      :url => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit guideline form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", guideline_path(@guideline), "post" do
      assert_select "input#guideline_name[name=?]", "guideline[name]"
      assert_select "input#guideline_organization[name=?]", "guideline[organization]"
      assert_select "input#guideline_url[name=?]", "guideline[url]"
      assert_select "input#guideline_description[name=?]", "guideline[description]"
    end
  end
end
