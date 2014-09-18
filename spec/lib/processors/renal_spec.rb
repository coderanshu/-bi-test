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
      check_guideline_step :first, false, false, 1

      Observation.create(:code => "71420008", :value => "3", :patient_id => @patient.id)
      @processor.check_for_hypovolemia @patient
      check_guideline_step :first, true, false, 2

      Observation.create(:code => "8480-6", :value => "101", :patient_id => @patient.id)
      @processor.check_for_hypovolemia @patient
      check_guideline_step :last, false, false, 1

      Observation.create(:code => "8480-6", :value => "99", :patient_id => @patient.id)
      @processor.check_for_hypovolemia @patient
      check_guideline_step :last, true, false, 2

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::HYPOVOLEMIA_ALERT
      alert.severity.should eql 5
    end
  end

  describe "check_for_decreased_urinary_output" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_decreased_urinary_output @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "duo_decreased_output", :value => "N", :patient_id => @patient.id)
      @processor.check_for_decreased_urinary_output @patient
      check_guideline_step :first, false, false, 1

      Observation.create(:code => "duo_decreased_output", :value => "Y", :patient_id => @patient.id)
      @processor.check_for_decreased_urinary_output @patient
      check_guideline_step :first, true, false, 1

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::DECREASED_URINARY_OUTPUT_ALERT
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
      check_guideline_step :first, false, false, 1

      Observation.create(:code => "2951-2", :value => "129", :patient_id => @patient.id)
      @processor.check_for_hyponatremia @patient
      check_guideline_step :first, true, false, 2

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
      check_guideline_step :first, false, false, 1

      Observation.create(:code => "2951-2", :value => "151", :patient_id => @patient.id)
      @processor.check_for_hypernatremia @patient
      check_guideline_step :first, true, false, 2

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::HYPERNATREMIA_ALERT
      alert.severity.should eql 5
    end
  end

  describe "check_for_gap_acidemia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_gap_acidemia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "needs data until all values present" do
      Observation.create(:code => "serum_sodium", :value => "140", :patient_id => @patient.id)
      @processor.check_for_gap_acidemia @patient
      check_guideline_step :first, false, true, 1

      Observation.create(:code => "serum_chloride", :value => "110", :patient_id => @patient.id)
      @processor.check_for_gap_acidemia @patient
      check_guideline_step :first, false, true, 2

      Observation.create(:code => "1963-8", :value => "24", :patient_id => @patient.id)
      @processor.check_for_gap_acidemia @patient
      check_guideline_step :first, false, false, 3
    end

    it "presents alert when threshold exceeded" do
      Observation.create(:code => "serum_sodium", :value => "140", :patient_id => @patient.id)
      @processor.check_for_gap_acidemia @patient
      check_guideline_step :first, false, true, 1

      Observation.create(:code => "serum_chloride", :value => "110", :patient_id => @patient.id)
      @processor.check_for_gap_acidemia @patient
      check_guideline_step :first, false, true, 2

      Observation.create(:code => "1963-8", :value => "24", :patient_id => @patient.id)
      @processor.check_for_gap_acidemia @patient
      check_guideline_step :first, false, false, 3

      Observation.create(:code => "serum_chloride", :value => "100", :patient_id => @patient.id)
      @processor.check_for_gap_acidemia @patient
      check_guideline_step :first, true, false, 3

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::GAP_ACIDEMIA_ALERT
      alert.severity.should eql 5
    end
  end

  describe "check_for_acidemia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_acidemia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "ApH", :value => "7.35", :patient_id => @patient.id)
      @processor.check_for_acidemia @patient
      check_guideline_step :first, false, false, 1

      Observation.create(:code => "ApH", :value => "7.3", :patient_id => @patient.id)
      @processor.check_for_acidemia @patient
      check_guideline_step :first, true, false, 2

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::ACIDEMIA_ALERT
      alert.severity.should eql 5
    end
  end
  
  describe "check_for_alkalemia" do
    it "establishes patient on guideline" do
      lambda {
        @processor.check_for_alkalemia @patient
      }.should change(PatientGuideline, :count).by(1)
      check_guideline_step :last, false, true
    end

    it "puts patient on guideline when threshold exceeded" do
      Observation.create(:code => "ApH", :value => "7.45", :patient_id => @patient.id)
      @processor.check_for_alkalemia @patient
      check_guideline_step :first, false, false, 1

      Observation.create(:code => "ApH", :value => "7.5", :patient_id => @patient.id)
      @processor.check_for_alkalemia @patient
      check_guideline_step :first, true, false, 2

      alert = Alert.last
      alert.alert_type.should eql Processor::Renal::ALKALEMIA_ALERT
      alert.severity.should eql 5
    end
  end
end