module Processor
  class Infectious
    BODY_SYSTEM = 6

    # Alert type codes to uniquely identify each type of alert
    SEPSIS_ALERT = 60
    URINARY_TRACT_INFECTION_ALERT = 61
    POSITIVE_URINE_CULTURE_ALERT = 62
    POSITIVE_RESPIRATORY_CULTURE_ALERT = 63
    FEVER_ALERT = 64
    BACTEREMIA_ALERT = 65

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_sepsis patient
        check_for_bacteremia patient
        check_for_urinary_tract_infection patient
        check_for_positive_urine_culture patient
        check_for_positive_respiratory_culture patient
        check_for_fever patient
      end
    end

    def check_for_sepsis patient
      guideline = Guideline.find_by_code("INFECTIOUS_SEPSIS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps.first.id, pg.id)
      observations = patient.observations.find(:all, :conditions => ["code IN (?)", ["positive_sepsis"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = observations.any? { |obs| (obs.value == "Y") }
        GuidelineManager::update_step(step1, is_met[0], false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, SEPSIS_ALERT, 5, "Gram positive sepsis", "194394004", "Gram positive sepsis", "SNOMEDCT") if is_met[0]
      end

      puts "Patient guideline step requires data"
      GuidelineManager::update_step(step1, false, true) unless has_data[0]
    end

    def check_for_bacteremia patient
      guideline = Guideline.find_by_code("INFECTIOUS_BACTEREMIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps.first.id, pg.id)
      observations = patient.observations.find(:all, :conditions => ["code IN (?)", ["positive_bacteremia"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = observations.any? { |obs| (obs.value == "Y") }
        GuidelineManager::update_step(step1, is_met[0], false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, BACTEREMIA_ALERT, 5, "Bacteremia", "5758002", "Bacteremia", "SNOMEDCT") if is_met[0]
      end

      puts "Patient guideline step requires data"
      GuidelineManager::update_step(step1, false, true) unless has_data[0]
    end

    def check_for_urinary_tract_infection patient
    end

    def check_for_positive_urine_culture patient
      guideline = Guideline.find_by_code("INFECTIOUS_PUC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps.first.id, pg.id)
      observations = patient.observations.find(:all, :conditions => ["code IN (?)", ["positive_urine"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = observations.any? { |obs| (obs.value == "Y") }
        GuidelineManager::update_step(step1, is_met[0], false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, POSITIVE_URINE_CULTURE_ALERT, 5, "Positive urine culture", "XXXXXX", "Positive urine culture", "SNOMEDCT") if is_met[0]
      end

      puts "Patient guideline step requires data"
      GuidelineManager::update_step(step1, false, true) unless has_data[0]
    end

    def check_for_positive_respiratory_culture patient
      guideline = Guideline.find_by_code("INFECTIOUS_PRC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps.first.id, pg.id)
      observations = patient.observations.find(:all, :conditions => ["code IN (?)", ["positive_respiratory"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = observations.any? { |obs| (obs.value == "Y") }
        GuidelineManager::update_step(step1, is_met[0], false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, POSITIVE_RESPIRATORY_CULTURE_ALERT, 5, "Positive respiratory culture", "XXXXXX", "Positive respiratory culture", "SNOMEDCT") if is_met[0]
      end

      puts "Patient guideline step requires data"
      GuidelineManager::update_step(step1, false, true) unless has_data[0]
    end

    def check_for_fever patient
      guideline = Guideline.find_by_code("INFECTIOUS_FEVER")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Check for high temperature
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["temperature", "LP29701-7"]])
      unless observations.blank?
        has_data[0] = true
        found_obs = (observations.select { |obs| (obs.value.to_f > 101.5) }).first
        is_met[0] = !found_obs.blank?
        GuidelineManager::update_step(step1, is_met[0], false)
      end

      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, FEVER_ALERT, 5, "Fever", "386661006", "Fever", "SNOMEDCT") if is_met[0]
    end
  end
end