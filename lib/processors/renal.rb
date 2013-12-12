module Processor
  class Renal
    BODY_SYSTEM = 5

    # Alert type codes to uniquely identify each type of alert
    HYPOVOLEMIA_ALERT = 50
    DECREASED_URINARY_OUTPUT_ALERT = 51
    ACUTE_KIDNEY_INJURY_ALERT = 52
    HYPONATREMIA_ALERT = 53
    HYPERNATREMIA_ALERT = 54

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_hypovolemia patient
        check_for_decreased_urinary_output patient
        check_for_acute_kidney_injury patient
        check_for_hyponatremia patient
        check_for_hypernatremia patient
      end
    end

    def check_for_hypovolemia patient
      guideline = Guideline.find_by_code("RENAL_HVLM")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["hvlm_low_pressure"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value == "Y") })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPOVOLEMIA_ALERT, 5, "Hypovolemia", "276.52", "Hypovolemia", "ICD9CM") if is_met[0]
    end

    def check_for_decreased_urinary_output patient
      guideline = Guideline.find_by_code("RENAL_HVLM")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["duo_decreased_output"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value == "Y") })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, DECREASED_URINARY_OUTPUT_ALERT, 5, "Decreased Urinary Output", "788.5", "Oliguria", "ICD9CM") if is_met[0]
    end

    def check_for_acute_kidney_injury patient
      guideline = Guideline.find_by_code("RENAL_AKI")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["creatinine", "2161-8"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value.to_f >= 2.5) })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_KIDNEY_INJURY_ALERT, 5, "Acute Kidney Injury", "584", "Acute kidney injury", "ICD9CM") if is_met[0]
    end

    def check_for_hyponatremia patient
      guideline = Guideline.find_by_code("RENAL_HPONT")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["serum_sodium"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value.to_i < 130) })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPONATREMIA_ALERT, 5, "Hyponatremia", "89627008", "Hyponatremia", "SNOMEDCT") if is_met[0]
    end

    def check_for_hypernatremia patient
      guideline = Guideline.find_by_code("RENAL_HPRNT")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["serum_sodium"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value.to_i > 150) })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPERNATREMIA_ALERT, 5, "Hypernatremia", "39355002", "Hypernatremia", "SNOMEDCT") if is_met[0]
    end
  end
end