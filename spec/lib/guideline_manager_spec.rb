require 'spec_helper'
require './lib/guideline_manager'

describe GuidelineManager do
  describe "establish_patient_on_guideline" do
    it "stops when patient or guideline are nil" do
      GuidelineManager.establish_patient_on_guideline(nil, nil).should be_false
    end
    
    it "adds a patient to a guideline" do
      lambda { 
        GuidelineManager.establish_patient_on_guideline(Patient.first, Guideline.first).should be_true
      }.should change(PatientGuideline, :count).by(1)
    end
    
    it "only adds a patient once to a guideline" do
      lambda {
        GuidelineManager.establish_patient_on_guideline(Patient.first, Guideline.first).should be_true 
        GuidelineManager.establish_patient_on_guideline(Patient.first, Guideline.first).should be_true
      }.should change(PatientGuideline, :count).by(1)
    end
  end
  
  describe "process_guideline_step" do
    before(:each) do
      @patient = Patient.first
      @patient_guideline = GuidelineManager.establish_patient_on_guideline(@patient, Guideline.first)
      @pass_proc = Proc.new { |patient, codes, validation_check| [true, true] }
      @fail_proc = Proc.new { |patient, codes, validation_check| [false, false] }
      @validation_check = Proc.new { |observations| true }
    end
  
    it "should process step when parameters exist" do
      Processor::Helper.should_receive(:find_guideline_step).and_return(PatientGuidelineStep.new)
      GuidelineManager.process_guideline_step(@patient, [], @patient_guideline, 1, @pass_proc, @validation_check).should eql([true, true])
    end
    
    it "should handle if step is missing" do
      Processor::Helper.should_receive(:find_guideline_step).and_return(nil)
      GuidelineManager.process_guideline_step(@patient, [], @patient_guideline, 1, @fail_proc, @validation_check).should be_nil
    end
  end
  
  describe "create_alert" do
    before(:each) do
      @patient = Patient.first
      @guideline = Guideline.first
      @patient_guideline = GuidelineManager.establish_patient_on_guideline(@patient, Guideline.first)
      @pass_proc = Proc.new { |patient, codes, validation_check| [true, true] }
      @fail_proc = Proc.new { |patient, codes, validation_check| [false, false] }
      @validation_check = Proc.new { |observations| true }
    end
    
    it "defaults severity and code system parameters" do
      alert = GuidelineManager.create_alert(@patient, @guideline, 1, 1, nil, "Test", "Test", "Test Desc", nil)
      alert.severity.should eql(3)
      alert.problems.first.observation.code_system.should eql("SNOMEDCT")
    end
    
    it "doesn't create a problem if details are blank" do
      alert = GuidelineManager.create_alert(@patient, @guideline, 1, 1, nil, "Test", "", "", nil)
      alert.problems.should be_blank
    end
    
    it "only creates an alert once" do
      lambda {
        2.times { GuidelineManager.create_alert(@patient, @guideline, 1, 1, nil, "Test", "", "", nil) }
      }.should change(Alert, :count).by(1)
    end
  end
end