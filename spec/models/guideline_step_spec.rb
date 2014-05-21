# == Schema Information
#
# Table name: guideline_steps
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :string(255)
#  order        :integer
#  guideline_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :string(255)
#

require 'spec_helper'

describe GuidelineStep do
  describe "active scope" do
    before(:each) do
      @guideline = Guideline.create(:name => "Test", :code => "TEST_CODE", :organization => "Bedside Intelligence", :body_system_id => 1)
      @step = GuidelineStep.create(:guideline_id => @guideline.id, :name => "Test Step", :description => "Test Step", :order => 1)
    end

    it "shows null" do
      GuidelineStep.active.find_all_by_guideline_id(@guideline.id).length.should eql(1)
    end
    it "shows active" do
      @step.update_attributes(:status => "active")
      GuidelineStep.active.find_all_by_guideline_id(@guideline.id).length.should eql(1)
    end
    it "shows other" do
      @step.update_attributes(:status => "random value")
      GuidelineStep.active.find_all_by_guideline_id(@guideline.id).length.should eql(1)
    end
    it "hides retired" do
      @step.update_attributes(:status => "retired")
      GuidelineStep.active.find_all_by_guideline_id(@guideline.id).length.should eql(0)
    end
  end
end
