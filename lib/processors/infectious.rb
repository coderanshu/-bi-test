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

    TEMPERATURE_THRESHOLD = 101.5

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

    # A single temperature > 101.5
    def temperature_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.float_above_value(obs, TEMPERATURE_THRESHOLD) })
      end
    end

    def check_for_sepsis patient
      guideline = Guideline.find_by_code("INFECTIOUS_SEPSIS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["positive_sepsis"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)

      observations = Hash.new
      observations["Positive for Sepsis?"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, SEPSIS_ALERT, 5, "Gram positive sepsis", "194394004", "Gram positive sepsis", "SNOMEDCT") if is_met[0]
    end

    def check_for_bacteremia patient
      guideline = Guideline.find_by_code("INFECTIOUS_BACTEREMIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["positive_bacteremia"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)

      observations = Hash.new
      observations["Positive for Bacteremia"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, BACTEREMIA_ALERT, 5, "Bacteremia", "5758002", "Bacteremia", "SNOMEDCT") if is_met[0]
    end

    def check_for_urinary_tract_infection patient
    end

    def check_for_positive_urine_culture patient
      guideline = Guideline.find_by_code("INFECTIOUS_PUC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["positive_urine"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)

      observations = Hash.new
      observations["Positive Urine Culture"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, POSITIVE_URINE_CULTURE_ALERT, 5, "Positive urine culture", "XXXXXX", "Positive urine culture", "SNOMEDCT") if is_met[0]
    end

    def check_for_positive_respiratory_culture patient
      guideline = Guideline.find_by_code("INFECTIOUS_PRC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["positive_respiratory"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)

      observations = Hash.new
      observations["Positive Respiratory Culture"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, POSITIVE_RESPIRATORY_CULTURE_ALERT, 5, "Positive respiratory culture", "XXXXXX", "Positive respiratory culture", "SNOMEDCT") if is_met[0]
    end

    def check_for_fever patient
      guideline = Guideline.find_by_code("INFECTIOUS_FEVER")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["temperature", "LP29701-7"], pg, 0, Helper.any_code_exists_proc, temperature_check)

      observations = Hash.new
      observations["Temperature"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, FEVER_ALERT, 5, "Fever", "386661006", "Fever", "SNOMEDCT") if is_met[0]
    end
  end
end