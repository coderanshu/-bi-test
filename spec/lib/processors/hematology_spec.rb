require 'spec_helper'
require './lib/guideline_manager'
require './lib/processors/hematology'

describe Processor::Hematology do
  before(:each) do
    @patient = Patient.first
    @processor = Processor::Hematology.new(@patient)
  end

  describe "check_for_low_hemoglobin" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_low_hemoglobin @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end
  end
  
  describe "check_for_low_hemoglobin" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_low_hemoglobin @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end
    
    it "establishes status and alert for high alkaline phosphatase observations" do
      Observation.create(:code => "4635-9", :value => "8", :patient_id => @patient.id)
      @processor.check_for_low_hemoglobin @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "4635-9", :value => "7.0", :patient_id => @patient.id)
      @processor.check_for_low_hemoglobin @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Hematology::HEMOGLOBIN_ABNORMAL_LOW_ALERT
    end
  end
  
  describe "check_for_low_neutrophil" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_low_neutrophil @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end
    
    it "establishes status and alert for low ANC observations" do
      Observation.create(:code => "abnormal_low_neutrophil_count", :value => "N", :patient_id => @patient.id)
      @processor.check_for_low_neutrophil @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "abnormal_low_neutrophil_count", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_low_neutrophil @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Hematology::LOW_NEUTROPHIL_ALERT
    end
    
    it "establishes status and alert for calculated low ANC" do
      Observation.create(:code => "26464-8", :value => "1500", :patient_id => @patient.id)  #WBC
      Observation.create(:code => "pct_neutrophils", :value => "0.15", :patient_id => @patient.id)
      @processor.check_for_low_neutrophil @patient
      check_guideline_step :last, false, true  # Doesn't have all of the pieces of data yet
      
      Observation.create(:code => "pct_bands", :value => "0.55", :patient_id => @patient.id)
      @processor.check_for_low_neutrophil @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "pct_bands", :value => "0.05", :patient_id => @patient.id)
      @processor.check_for_low_neutrophil @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Hematology::LOW_NEUTROPHIL_ALERT
    end
  end
  
  describe "check_for_low_platelets" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_low_platelets @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end
    
    it "establishes status and alert for high alkaline phosphatase observations" do
      Observation.create(:code => "26515-7", :value => "500", :patient_id => @patient.id)
      @processor.check_for_low_platelets @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "26515-7", :value => "40", :patient_id => @patient.id)
      @processor.check_for_low_platelets @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Hematology::PLATELETS_ABNORMAL_LOW_ALERT
    end
  end
end