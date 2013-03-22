require 'spec_helper'

describe "questions/edit" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :guideline_step_id => 1,
      :code => "MyString",
      :display => "MyString",
      :question_type => "MyString",
      :constraints => "MyString",
      :order => 1
    ))
  end

  it "renders the edit question form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", question_path(@question), "post" do
      assert_select "input#question_guideline_step_id[name=?]", "question[guideline_step_id]"
      assert_select "input#question_code[name=?]", "question[code]"
      assert_select "input#question_display[name=?]", "question[display]"
      assert_select "input#question_question_type[name=?]", "question[question_type]"
      assert_select "input#question_constraints[name=?]", "question[constraints]"
      assert_select "input#question_order[name=?]", "question[order]"
    end
  end
end
