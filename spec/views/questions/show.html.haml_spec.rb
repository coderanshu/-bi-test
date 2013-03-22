require 'spec_helper'

describe "questions/show" do
  before(:each) do
    @question = assign(:question, stub_model(Question,
      :guideline_step_id => 1,
      :code => "Code",
      :display => "Display",
      :question_type => "Question Type",
      :constraints => "Constraints",
      :order => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Code/)
    rendered.should match(/Display/)
    rendered.should match(/Question Type/)
    rendered.should match(/Constraints/)
    rendered.should match(/2/)
  end
end
