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

      # Check for low serum hemoglobin levels
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["HGB", "hemoglobin", "4635-9"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value.to_f <= 7.0) })
        GuidelineManager::update_step(step1, is_met[0], false)
      end

      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HEMOGLOBIN_ABNORMAL_LOW_ALERT, 5, "Anemia", "271737000", "Anemia (Low hemoglobin)", "SNOMEDCT") if is_met[0]
    end

    def check_for_low_platelets patient
      guideline = Guideline.find_by_code("HEMATOLOGY_ALP")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Check for low neutrophil count (computed observation)
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["platelets", "26515-7"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value.to_i < 50) })
        GuidelineManager::update_step(step1, is_met[0], false)
      end

      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, PLATELETS_ABNORMAL_LOW_ALERT, 5, "Heparin-induced thrombocytopenia", "XXXXXX", "Heparin-induced thrombocytopenia", "SNOMEDCT") if is_met[0]
    end

    def check_for_low_neutrophil patient
      guideline = Guideline.find_by_code("HEMATOLOGY_ALNC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Check for low neutrophil count (computed observation)
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["abnormal_low_neutrophil_count"]])
      unless observations.blank?
        has_data[0] = true
        found_obs = (observations.select { |obs| (obs.value == "Y") }).first
        is_met[0] = !found_obs.blank?
        GuidelineManager::update_step(step1, is_met[0], false)
      end

      # Check for low neutrophil count (calculated from measured values)
      unless (is_met[0])
        wbc_obs = patient.observations.all(:conditions => ["code IN (?)", ["WBC", "26464-8"]]).last
        pct_neutrophils_obs = patient.observations.all(:conditions => ["code IN (?)", ["pct_neutrophils"]]).last
        pct_bands_obs = patient.observations.all(:conditions => ["code IN (?)", ["pct_bands"]]).last
        unless wbc_obs.blank? or pct_neutrophils_obs.blank? or pct_bands_obs.blank?
          has_data[0] = true
          is_met[0] = ((pct_neutrophils_obs.value.to_f + pct_bands_obs.value.to_f) * wbc_obs.value.to_f) <= 500.0
          GuidelineManager::update_step(step1, is_met[0], false)
        end
      end

      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, LOW_NEUTROPHIL_ALERT, 5, "Abnormal low neutrophils", "XXXXXX", "Abnormal low neutrophils", "SNOMEDCT") if is_met[0]
    end
  end
end