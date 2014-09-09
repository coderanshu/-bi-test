require 'spec_helper'
require './lib/guideline_manager'
require './lib/processors/respiratory'

describe Processor::Respiratory do
  before(:each) do
    @patient = Patient.first
    @processor = Processor::Respiratory.new(@patient)
  end

  describe "calculate_tidal_volume" do
    it "provides a default if no height is available" do
      @processor.calculate_tidal_volume(@patient).should eql ""
    end

    it "calculates correct values based on height (cm)" do
      Observation.create(:code => "height", :value => "182", :patient_id => @patient.id)
      @processor.calculate_tidal_volume(@patient).should eql "Set tidal volume to 460.8 mL (based on ideal wt of 76.8 kg)"
    end

    it "calculates correct values based on height (in)" do
      Observation.create(:code => "height", :value => "70", :units => "in", :patient_id => @patient.id)
      @processor.calculate_tidal_volume(@patient).should eql "Set tidal volume to 438.0 mL (based on ideal wt of 73.0 kg)"
    end

    it "produces result for height below 5 ft" do
      Observation.create(:code => "height", :value => "127", :patient_id => @patient.id)
      @processor.calculate_tidal_volume(@patient).should eql "Set tidal volume to 162.0 mL (based on ideal wt of 27.0 kg)"
    end

    it "produces a default value if invalid/improbable data is available" do
      Observation.create(:code => "height", :value => "3", :patient_id => @patient.id)
      @processor.calculate_tidal_volume(@patient).should eql ""
    end
  end

  describe "check_for_acute_respiratory_distress" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_acute_respiratory_distress @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "establishes probable status for pressure below threshold" do
      Observation.create(:code => "paO2", :value => "68", :patient_id => @patient.id)
      @processor.check_for_acute_respiratory_distress @patient
      check_guideline_step :first, false, true

      Observation.create(:code => "fiO2", :value => ".6", :patient_id => @patient.id)
      @processor.check_for_acute_respiratory_distress @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Respiratory::ACUTE_RESPIRATORY_DISTRESS_ALERT
      alert.severity.should eql 3

      Observation.create(:code => "fiO2", :value => ".2", :patient_id => @patient.id)
      @processor.check_for_acute_respiratory_distress @patient
      check_guideline_step :first, false, false
    end

    it "confirms ARDS for all values" do
      Observation.create(:code => "paO2", :value => "68", :patient_id => @patient.id)
      @processor.check_for_acute_respiratory_distress @patient
      check_guideline_step :first, false, true

      Observation.create(:code => "fiO2", :value => ".6", :patient_id => @patient.id)
      @processor.check_for_acute_respiratory_distress @patient
      check_guideline_step :first, true, false

      Observation.create(:code => "ards_confirmed_chest_radiograph", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_acute_respiratory_distress @patient
      check_guideline_step :last, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Respiratory::ACUTE_RESPIRATORY_DISTRESS_ALERT
      alert.severity.should eql 5
    end
  end
  
  describe "check_for_pneumonia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_pneumonia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "43441-5", :value => "1000", :patient_id => @patient.id)
      @processor.check_for_pneumonia @patient
      check_guideline_step :first, false, false

      Observation.create(:code => "43441-5", :value => "1001", :patient_id => @patient.id)
      @processor.check_for_pneumonia @patient
      check_guideline_step :first, true, false

      alert = Alert.last
      alert.alert_type.should eql Processor::Respiratory::PNEUMONIA_ALERT
      alert.severity.should eql 5
    end
  end
end