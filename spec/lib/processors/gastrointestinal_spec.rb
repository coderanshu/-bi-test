require 'spec_helper'
require './lib/guideline_manager'
require './lib/processors/gastrointestinal'

describe Processor::Gastrointestinal do
  before(:each) do
    @patient = Patient.first
    @processor = Processor::Gastrointestinal.new(@patient)
  end

  describe "check_for_liver_disfunction" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_liver_disfunction @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end
    
    it "establishes status and alert for high AST observations (female)" do
      @patient.update_attributes(:gender => "F")
      Observation.create(:code => "1920-8", :value => "101", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step -2, false, false
      
      Observation.create(:code => "1920-8", :value => "105", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step -2, true, false
      Alert.last.alert_type.should eql Processor::Gastrointestinal::LIVER_DISFUNCTION_ALERT
    end
    
    it "establishes status and alert for high AST observations (male)" do
      @patient.update_attributes(:gender => "M")
      Observation.create(:code => "1920-8", :value => "110", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step -2, false, false
      
      Observation.create(:code => "1920-8", :value => "125", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step -2, true, false
      Alert.last.alert_type.should eql Processor::Gastrointestinal::LIVER_DISFUNCTION_ALERT
    end
    
    it "establishes status and alert for high ALT observations (female)" do
      @patient.update_attributes(:gender => "F")
      Observation.create(:code => "1742-6", :value => "55", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "1742-6", :value => "110", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Gastrointestinal::LIVER_DISFUNCTION_ALERT
    end
    
    it "establishes status and alert for high ALT observations (male)" do
      @patient.update_attributes(:gender => "M")
      Observation.create(:code => "1742-6", :value => "115", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step :last, false, false
      
      Observation.create(:code => "1742-6", :value => "136", :patient_id => @patient.id)
      @processor.check_for_liver_disfunction @patient
      check_guideline_step :last, true, false
      Alert.last.alert_type.should eql Processor::Gastrointestinal::LIVER_DISFUNCTION_ALERT
    end
  end
end