# == Schema Information
#
# Table name: guidelines
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  organization   :string(255)
#  url            :string(255)
#  description    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  body_system_id :integer
#  code           :string(255)
#  status         :string(255)
#

require 'spec_helper'

describe Guideline do
  describe "active scope" do
    before(:each) do
      @guideline = Guideline.create(:name => "Test", :code => "TEST_CODE", :organization => "Bedside Intelligence", :body_system_id => 1)
    end

    it "shows null" do
      Guideline.active.find_all_by_code("TEST_CODE").length.should eql(1)
    end
    it "shows active" do
      @guideline.update_attributes(:status => "active")
      Guideline.active.find_all_by_code("TEST_CODE").length.should eql(1)
    end
    it "shows other" do
      @guideline.update_attributes(:status => "random value")
      Guideline.active.find_all_by_code("TEST_CODE").length.should eql(1)
    end
    it "hides retired" do
      @guideline.update_attributes(:status => "retired")
      Guideline.active.find_all_by_code("TEST_CODE").length.should eql(0)
    end
  end
end
