require 'spec_helper'

describe "guideline_steps/edit" do
  before(:each) do
    @guideline_step = assign(:guideline_step, stub_model(GuidelineStep,
      :name => "MyString",
      :description => "MyString",
      :order => 1,
      :guideline_id => 1
    ))
  end

  it "renders the edit guideline_step form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", guideline_step_path(@guideline_step), "post" do
      assert_select "input#guideline_step_name[name=?]", "guideline_step[name]"
      assert_select "input#guideline_step_description[name=?]", "guideline_step[description]"
      assert_select "input#guideline_step_order[name=?]", "guideline_step[order]"
      assert_select "input#guideline_step_guideline_id[name=?]", "guideline_step[guideline_id]"
    end
  end
end
