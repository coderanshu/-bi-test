require 'spec_helper'
require './lib/processors/helper'

describe Processor::Helper do
  before(:each) do
    @patient = Patient.first
  end

  describe "find_all_items" do
    it "returns nil if there are no codes" do
      Processor::Helper.find_all_items(@patient, []).should be_nil
      Processor::Helper.find_all_items(@patient, nil).should be_nil
    end

    it "returns nil if the patient is nil" do
      Processor::Helper.find_all_items(nil, ["1000"]).should be_nil
    end
  end

  describe "consecutive_days_with_observation" do
    it "only counts the same day once" do
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id, :observed_on => DateTime.now)
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id, :observed_on => DateTime.now)
      Processor::Helper.consecutive_days_with_observation(@patient.observations, 2).should be_false
    end

    it "ignores observations without observation dates" do
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id)
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id)
      Processor::Helper.consecutive_days_with_observation(@patient.observations, 2).should be_false
    end

    it "identifies consecutive days" do
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id, :observed_on => DateTime.now)
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id, :observed_on => (DateTime.now - 1))
      Processor::Helper.consecutive_days_with_observation(@patient.observations, 2).should be_true
    end

    it "ignores non-consecutive days" do
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id, :observed_on => DateTime.now)
      Observation.create(:code => "vent_support", :value => "Yes", :patient_id => @patient.id, :observed_on => (DateTime.now - 2))
      Processor::Helper.consecutive_days_with_observation(@patient.observations, 2).should be_false
    end
  end
end