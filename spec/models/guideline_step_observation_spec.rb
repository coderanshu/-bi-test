# == Schema Information
#
# Table name: guildeline_step_observations
#
#  id                        :integer          not null, primary key
#  patient_guideline_step_id :integer
#  observation_id            :integer
#  order                     :integer
#  group                     :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'spec_helper'

describe GuidelineStepObservation do
  before(:each) do
    @patient = Patient.create(:first_name => "Test", :last_name => "Patient")
    @guideline = Guideline.create(:name => "Test", :code => "TEST_CODE", :organization => "Bedside Intelligence", :body_system_id => 1)
    @step = GuidelineStep.create(:guideline_id => @guideline.id, :name => "Test Step", :description => "Test Step", :order => 1)
    @patient_step = PatientGuidelineStep.create(:patient_id => @patient.id, :guideline_step_id => @step.id)
    @observation1 = Observation.create(:name => "Obs1", :value => "Test 1", :patient_id => @patient.id)
    @observation2 = Observation.create(:name => "Obs2", :value => "Test 2", :patient_id => @patient.id)
  end

  describe "process_list" do
    it "ignores nil lists" do
      GuidelineStepObservation.process_list(@patient_step.id, nil)
      GuidelineStepObservation.find_by_patient_guideline_step_id(@patient_step.id).should be_nil
    end

    it "ignores empty lists" do
      GuidelineStepObservation.process_list(@patient_step.id, [])
      GuidelineStepObservation.find_by_patient_guideline_step_id(@patient_step.id).should be_nil
    end

    it "handles a single group" do
      observations = Hash.new
      observations["group1"] = [@observation1]
      GuidelineStepObservation.process_list(@patient_step.id, observations)
      gso = GuidelineStepObservation.find_all_by_patient_guideline_step_id(@patient_step.id)
      gso.length.should eql 1
      gso[0].observation_id.should eql @observation1.id
      gso[0].group.should eql "group1"
      gso[0].order.should eql 1
    end

    it "clears out existing entries when data changes" do
      observations = Hash.new
      observations["group1"] = [@observation1]
      GuidelineStepObservation.process_list(@patient_step.id, observations)
      GuidelineStepObservation.process_list(@patient_step.id, nil)
      gso = GuidelineStepObservation.find_all_by_patient_guideline_step_id(@patient_step.id)
      gso.length.should eql 0
    end

    it "handles multiple groups" do
      observations = Hash.new
      observations["group1"] = [@observation1]
      observations["group2"] = [@observation2]
      GuidelineStepObservation.process_list(@patient_step.id, observations)
      gso = GuidelineStepObservation.find_all_by_patient_guideline_step_id(@patient_step.id)
      gso.length.should eql 2
      gso[0].observation_id.should eql @observation1.id
      gso[0].group.should eql "group1"
      gso[1].observation_id.should eql @observation2.id
      gso[1].group.should eql "group2"
    end

    it "orders items in a group" do
      observations = Hash.new
      observations["group1"] = [@observation2, @observation1]
      GuidelineStepObservation.process_list(@patient_step.id, observations)
      gso = GuidelineStepObservation.find_all_by_patient_guideline_step_id(@patient_step.id)
      gso.length.should eql 2
      gso[0].observation_id.should eql @observation2.id
      gso[0].order.should eql 1
      gso[1].observation_id.should eql @observation1.id
      gso[1].order.should eql 2
    end
  end
end
