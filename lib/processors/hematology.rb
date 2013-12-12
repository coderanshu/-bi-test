module Processor
  class Hematology
    BODY_SYSTEM = 7

    # Alert type codes to uniquely identify each type of alert
    HEMOGLOBIN_ABNORMAL_LOW_ALERT = 70
    PLATELETS_ABNORMAL_LOW_ALERT = 71
    LOW_NEUTROPHIL_ALERT = 72

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_low_hemoglobin patient
        check_for_low_platelets patient
        check_for_low_neutrophil patient
      end
    end

    def check_for_low_hemoglobin patient
      guideline = Guideline.find_by_code("HEMATOLOGY_ALHGB")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Check for low hemoglobin levels
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["HGB", "hemoglobin", "726-0"]])
      unless observations.blank?
        has_data[0] = true
        found_obs = (observations.select { |obs| (obs.value.to_f <= 7.0) }).first
        is_met[0] = !found_obs.blank?
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HEMOGLOBIN_ABNORMAL_LOW_ALERT, 5, "Anemia", "271737000", "Anemia (Low hemoglobin)", "SNOMEDCT") if is_met[0]
    end

    def check_for_low_platelets patient
    end

    def check_for_low_neutrophil patient
      guideline = Guideline.find_by_code("HEMATOLOGY_ALNC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Check for low hemoglobin levels
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["neutrophil_count"]])
      unless observations.blank?
        has_data[0] = true
        found_obs = (observations.select { |obs| (obs.value.to_i <= 500) }).first
        is_met[0] = !found_obs.blank?
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, LOW_NEUTROPHIL_ALERT, 5, "Abnormal low neutrophils", "XXXXXX", "Abnormal low neutrophils", "SNOMEDCT") if is_met[0]
    end
  end
end