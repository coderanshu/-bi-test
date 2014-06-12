require 'spec_helper'
require './lib/guideline_manager'
require './lib/processors/neurologic'

describe Processor::Neurologic do
  before(:each) do
    @patient = Patient.first
    @processor = Processor::Neurologic.new(@patient)
  end

  describe "check_for_delirium" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_delirium @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline for pseuod-value" do
      Observation.create(:code => "delirium_screening", :value => "N", :patient_id => @patient.id)
      @processor.check_for_delirium @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "delirium_screening", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_delirium @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Neurologic::DELIRIUM_ALERT
      alert.severity.should eql 5
    end
    
    it "puts patient on guideline when positive screening exists" do
      Observation.create(:code => "LP74647-6", :value => "NEG", :patient_id => @patient.id)
      @processor.check_for_delirium @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "LP74647-6", :value => "POS", :patient_id => @patient.id)
      @processor.check_for_delirium @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Neurologic::DELIRIUM_ALERT
      alert.severity.should eql 5
    end
  end
  
  describe "check_for_alcohol_withdrawal" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_alcohol_withdrawal @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end
    
    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "ciwa_score", :value => "14", :patient_id => @patient.id)
      @processor.check_for_alcohol_withdrawal @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "ciwa_score", :value => "15", :patient_id => @patient.id)
      @processor.check_for_alcohol_withdrawal @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Neurologic::ALCOHOL_WITHDRAWAL_ALERT
      alert.severity.should eql 5
    end
  end
  
  describe "check_for_altered_mental_status" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_altered_mental_status @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :first, false, true
      check_guideline_step :last, false, true
    end
    
    it "puts patient on guideline when pseudo-value set" do
      Observation.create(:code => "glasgow_coma_decrease", :value => "N", :patient_id => @patient.id)
      @processor.check_for_altered_mental_status @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "glasgow_coma_decrease", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_altered_mental_status @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Neurologic::ALTERED_MENTAL_STATUS_ALERT
      alert.severity.should eql 5
    end
    
    it "puts patient on guideline when value goes below baseline" do
      Observation.create(:code => "glasgow_score", :value => "12", :patient_id => @patient.id)
      @processor.check_for_altered_mental_status @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "glasgow_score", :value => "11", :patient_id => @patient.id)
      @processor.check_for_altered_mental_status @patient
      check_guideline_step :first, false, false
      
      Observation.create(:code => "glasgow_score", :value => "9", :patient_id => @patient.id)
      @processor.check_for_altered_mental_status @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Neurologic::ALTERED_MENTAL_STATUS_ALERT
      alert.severity.should eql 5
    end
    
    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "glasgow_score", :value => "9", :patient_id => @patient.id)
      @processor.check_for_altered_mental_status @patient
      check_guideline_step :last, false, false

      Observation.create(:code => "glasgow_score", :value => "8", :patient_id => @patient.id)
      @processor.check_for_altered_mental_status @patient
      check_guideline_step :last, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Neurologic::ALTERED_MENTAL_STATUS_ALERT
      alert.severity.should eql 5
    end
  end
end