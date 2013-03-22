require 'spec_helper'

describe "responses/index" do
  before(:each) do
    assign(:responses, [
      stub_model(Response,
        :question_id => 1,
        :patient_id => 2,
        :value => "Value"
      ),
      stub_model(Response,
        :question_id => 1,
        :patient_id => 2,
        :value => "Value"
      )
    ])
  end

  it "renders a list of responses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
  end
end
