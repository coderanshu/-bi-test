require 'spec_helper'
require './lib/guideline_manager'
require './lib/processors/cardiac'

describe Processor::Cardiac do
  before(:each) do
    @patient = Patient.first
    @processor = Processor::Cardiac.new(@patient)
  end

  describe "check_for_acute_myocardial_infarction" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_acute_myocardial_infarction @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end
    
    it "establishes data present for in-range values" do
      Observation.create(:code => "cardiac_troponin_i", :value => "1", :patient_id => @patient.id, :units => "mcg/mL")
      @processor.check_for_acute_myocardial_infarction @patient
      check_guideline_step :last, false, false
    end
    
    it "establishes alert" do
      Observation.create(:code => "cardiac_troponin_i", :value => "3", :patient_id => @patient.id, :units => "mcg/mL")
      @processor.check_for_acute_myocardial_infarction @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ACUTE_MI_ALERT
    end
  end
  
  describe "check_for_abnormal_high_function" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_abnormal_high_function @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
      check_guideline_step -2, false, true
    end
    
    it "establishes status and alert for high SBP pseudo-value" do
      Observation.create(:code => "two_high_systolic_bp", :value => "N", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step -2, false, false
      
      Observation.create(:code => "two_high_systolic_bp", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step -2, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_HIGH_FUNCTION_ALERT
    end
    
    it "establishes status and alert for high SBP observations" do
      Observation.create(:code => "8480-6", :value => "250", :patient_id => @patient.id)
      Observation.create(:code => "8480-6", :value => "150", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step -2, false, false
      
      Observation.create(:code => "8480-6", :value => "250", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step -2, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_HIGH_FUNCTION_ALERT
    end
    
    it "establishes status and alert for high heart rate pseudo-value" do
      Observation.create(:code => "two_high_heart_rate", :value => "N", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "two_high_heart_rate", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_HIGH_FUNCTION_ALERT
    end
    
    it "establishes status and alert for high heart rate observations" do
      Observation.create(:code => "LP32063-7", :value => "160", :patient_id => @patient.id)
      Observation.create(:code => "LP32063-7", :value => "130", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "LP32063-7", :value => "160", :patient_id => @patient.id)
      @processor.check_for_abnormal_high_function @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_HIGH_FUNCTION_ALERT
    end
  end
  
  describe "check_for_abnormal_low_function" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_abnormal_low_function @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
      check_guideline_step -2, false, true
    end
    
    it "establishes status and alert for high SBP pseudo-value" do
      Observation.create(:code => "two_low_systolic_bp", :value => "N", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step -2, false, false
      
      Observation.create(:code => "two_low_systolic_bp", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step -2, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_LOW_FUNCTION_ALERT
    end
    
    it "establishes status and alert for high SBP observations" do
      Observation.create(:code => "8480-6", :value => "89", :patient_id => @patient.id)
      Observation.create(:code => "8480-6", :value => "150", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step -2, false, false
      
      Observation.create(:code => "8480-6", :value => "89", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step -2, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_LOW_FUNCTION_ALERT
    end
    
    it "establishes status and alert for high heart rate pseudo-value" do
      Observation.create(:code => "two_low_heart_rate", :value => "N", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "two_low_heart_rate", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_LOW_FUNCTION_ALERT
    end
    
    it "establishes status and alert for high heart rate observations" do
      Observation.create(:code => "LP32063-7", :value => "38", :patient_id => @patient.id)
      Observation.create(:code => "LP32063-7", :value => "40", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "LP32063-7", :value => "37", :patient_id => @patient.id)
      @processor.check_for_abnormal_low_function @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Cardiac::ABNORMAL_LOW_FUNCTION_ALERT
    end
  end
end