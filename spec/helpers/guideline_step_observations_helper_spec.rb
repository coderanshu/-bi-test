require 'spec_helper'

describe GuidelineStepObservationsHelper do
  describe "format_observation_value_for_display" do
    before(:each) do
      @guideline = Guideline.create(:name => "Test", :body_system_id => 1)
      @step = GuidelineStep.create(:guideline_id => @guideline.id, :name => "Test Step", :order => 1)
    end

    describe "translates yes/no questions" do
      it "translates yes/no questions" do
        q = Question.create(:guideline_step_id => @step.id, :code => "test_yn", :display => "Test Y/N", :question_type => "choice", :constraints => "YesNo")
        obs = Observation.create(:value => "Y", :question_id => q.id)
        format_observation_value_for_display(obs).should eql "Yes"
      end

      it "provides default value for unknown Y/N response" do
        q = Question.create(:guideline_step_id => @step.id, :code => "test_yn", :display => "Test Y/N", :question_type => "choice", :constraints => "YesNo")
        obs = Observation.create(:value => "P", :question_id => q.id)
        format_observation_value_for_display(obs).should eql "(Unknown)"
      end

      it "doesn't translate Y/N if not tied to question" do
        obs = Observation.create(:value => "Y")
        format_observation_value_for_display(obs).should eql "Y"
      end
    end
  end
end