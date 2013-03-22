require 'spec_helper'

describe "responses/new" do
  before(:each) do
    assign(:response, stub_model(Response,
      :question_id => 1,
      :patient_id => 1,
      :value => "MyString"
    ).as_new_record)
  end

  it "renders new response form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", responses_path, "post" do
      assert_select "input#response_question_id[name=?]", "response[question_id]"
      assert_select "input#response_patient_id[name=?]", "response[patient_id]"
      assert_select "input#response_value[name=?]", "response[value]"
    end
  end
end
