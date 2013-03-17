require 'spec_helper'

describe "guideline_steps/new" do
  before(:each) do
    assign(:guideline_step, stub_model(GuidelineStep,
      :name => "MyString",
      :description => "MyString",
      :order => 1,
      :guideline_id => 1
    ).as_new_record)
  end

  it "renders new guideline_step form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", guideline_steps_path, "post" do
      assert_select "input#guideline_step_name[name=?]", "guideline_step[name]"
      assert_select "input#guideline_step_description[name=?]", "guideline_step[description]"
      assert_select "input#guideline_step_order[name=?]", "guideline_step[order]"
      assert_select "input#guideline_step_guideline_id[name=?]", "guideline_step[guideline_id]"
    end
  end
end
