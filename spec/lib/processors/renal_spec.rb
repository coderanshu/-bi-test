require 'spec_helper'
require './lib/guideline_manager'
require './lib/processors/renal'

describe Processor::Renal do
  before(:each) do
    @patient = Patient.first
    @processor = Processor::Renal.new(@patient)
  end

  describe "check_for_hypovolemia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_hypovolemia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "71420008", :value => "4", :patient_id => @patient.id)
      @processor.check_for_hypovolemia @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "71420008", :value => "3", :patient_id => @patient.id)
      @processor.check_for_hypovolemia @patient
      check_guideline_step :first, true, false

      Observation.create(:code => "8480-6", :value => "101", :patient_id => @patient.id)
      @processor.check_for_hypovolemia @patient
      check_guideline_step :last, false, false

      Observation.create(:code => "8480-6", :value => "99", :patient_id => @patient.id)
      @processor.check_for_hypovolemia @patient
      check_guideline_step :last, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::HYPOVOLEMIA_ALERT
      alert.severity.should eql 5
    end
  end

  describe "check_for_hyponatremia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_hyponatremia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "2951-2", :value => "130", :patient_id => @patient.id)
      @processor.check_for_hyponatremia @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "2951-2", :value => "129", :patient_id => @patient.id)
      @processor.check_for_hyponatremia @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::HYPONATREMIA_ALERT
      alert.severity.should eql 5
    end
  end

  describe "check_for_hypernatremia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_hypernatremia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "2951-2", :value => "150", :patient_id => @patient.id)
      @processor.check_for_hypernatremia @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "2951-2", :value => "151", :patient_id => @patient.id)
      @processor.check_for_hypernatremia @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::HYPERNATREMIA_ALERT
      alert.severity.should eql 5
    end
  end
end