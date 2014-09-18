require 'spec_helper'
require './lib/guideline_manager'
require './lib/processors/infectious'

describe Processor::Infectious do
  before(:each) do
    @patient = Patient.first
    @processor = Processor::Infectious.new(@patient)
  end

  describe "check_for_sepsis" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_sepsis @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "establishes status and alert for positive sepsis observations" do
      Observation.create(:code => "positive_sepsis", :value => "N", :patient_id => @patient.id)
      @processor.check_for_sepsis @patient
      check_guideline_step :last, false, false, 1

      Observation.create(:code => "positive_sepsis", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_sepsis @patient
      check_guideline_step :last, true, false, 1
      Alert.last.alert_type.should eql Processor::Infectious::SEPSIS_ALERT
    end
  end

  describe "check_for_bacteremia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_bacteremia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "establishes status and alert for positive bacteremia observations" do
      Observation.create(:code => "positive_bacteremia", :value => "N", :patient_id => @patient.id)
      @processor.check_for_bacteremia @patient
      check_guideline_step :last, false, false, 1

      Observation.create(:code => "positive_bacteremia", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_bacteremia @patient
      check_guideline_step :last, true, false, 1
      Alert.last.alert_type.should eql Processor::Infectious::BACTEREMIA_ALERT
    end
  end

  describe "check_for_fever" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_fever @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "establishes status and alert for positive bacteremia observations" do
      Observation.create(:code => "LP29701-7", :value => "98.6", :patient_id => @patient.id)
      @processor.check_for_fever @patient
      check_guideline_step :last, false, false, 1

      Observation.create(:code => "LP29701-7", :value => "101.6", :patient_id => @patient.id)
      @processor.check_for_fever @patient
      check_guideline_step :last, true, false, 2
      Alert.last.alert_type.should eql Processor::Infectious::FEVER_ALERT
    end
  end

  describe "check_for_positive_urine_culture" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_positive_urine_culture @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "establishes status and alert for positive bacteremia observations" do
      Observation.create(:code => "positive_urine", :value => "N", :patient_id => @patient.id)
      @processor.check_for_positive_urine_culture @patient
      check_guideline_step :last, false, false, 1

      Observation.create(:code => "positive_urine", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_positive_urine_culture @patient
      check_guideline_step :last, true, false, 1
      Alert.last.alert_type.should eql Processor::Infectious::POSITIVE_URINE_CULTURE_ALERT
    end
  end

  describe "check_for_positive_respiratory_culture" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_positive_respiratory_culture @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "establishes status and alert for positive bacteremia observations" do
      Observation.create(:code => "positive_respiratory", :value => "N", :patient_id => @patient.id)
      @processor.check_for_positive_respiratory_culture @patient
      check_guideline_step :last, false, false, 1

      Observation.create(:code => "positive_respiratory", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_positive_respiratory_culture @patient
      check_guideline_step :last, true, false, 1
      Alert.last.alert_type.should eql Processor::Infectious::POSITIVE_RESPIRATORY_CULTURE_ALERT
    end
  end
end