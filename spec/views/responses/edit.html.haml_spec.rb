require 'spec_helper'

describe "responses/edit" do
  before(:each) do
    @response = assign(:response, stub_model(Response,
      :question_id => 1,
      :patient_id => 1,
      :value => "MyString"
    ))
  end

  it "renders the edit response form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", response_path(@response), "post" do
      assert_select "input#response_question_id[name=?]", "response[question_id]"
      assert_select "input#response_patient_id[name=?]", "response[patient_id]"
      assert_select "input#response_value[name=?]", "response[value]"
    end
  end
end
