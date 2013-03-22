require 'spec_helper'

describe "questions/index" do
  before(:each) do
    assign(:questions, [
      stub_model(Question,
        :guideline_step_id => 1,
        :code => "Code",
        :display => "Display",
        :question_type => "Question Type",
        :constraints => "Constraints",
        :order => 2
      ),
      stub_model(Question,
        :guideline_step_id => 1,
        :code => "Code",
        :display => "Display",
        :question_type => "Question Type",
        :constraints => "Constraints",
        :order => 2
      )
    ])
  end

  it "renders a list of questions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Display".to_s, :count => 2
    assert_select "tr>td", :text => "Question Type".to_s, :count => 2
    assert_select "tr>td", :text => "Constraints".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
