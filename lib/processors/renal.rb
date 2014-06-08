module Processor
  class Renal
    BODY_SYSTEM = 5

    # Alert type codes to uniquely identify each type of alert
    HYPOVOLEMIA_ALERT = 50
    DECREASED_URINARY_OUTPUT_ALERT = 51
    ACUTE_KIDNEY_INJURY_ALERT = 52
    HYPONATREMIA_ALERT = 53
    HYPERNATREMIA_ALERT = 54

    SBP_THRESHOLD = 100
    CVP_THRESHOLD = 3
    HYPON_SERUM_NA_THRESHOLD = 130
    HYPERN_SERUM_NA_THRESHOLD = 150


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

    # CVP <= 3mm Hg
    def central_venous_pressure_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.int_lt_eql_value(obs, CVP_THRESHOLD) })
      end
    end

    # Systolic BP <100 mm Hg
    def systolic_bp_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.int_below_value(obs, SBP_THRESHOLD) })
      end
    end

    # Serum sodium < 130
    def hypon_serum_na_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.int_below_value(obs, HYPON_SERUM_NA_THRESHOLD) })
      end
    end

    # Serum sodium > 150
    def hypern_serum_na_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.int_above_value(obs, HYPERN_SERUM_NA_THRESHOLD) })
      end
    end

    def check_for_hypovolemia patient
      guideline = Guideline.find_by_code("RENAL_HVLM")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false, false]
      is_met = [false, false, false, false]

      # First, check for low central venous pressure
      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["hvlm_low_pressure"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["CVP", "71420008"], pg, 0, Helper.any_code_exists_proc, central_venous_pressure_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      # Next, check for low SBP
      has_data[2], is_met[2] = GuidelineManager::process_guideline_step(patient, ["hvlm_low_sbp"], pg, 1, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[3], is_met[3] = GuidelineManager::process_guideline_step(patient, ["systolic_bp", "SBP", "8480-6"],
        pg, 1, Helper.any_code_exists_proc, systolic_bp_check) unless is_met[2]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[2] or is_met[3]), !(has_data[2] or has_data[3]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPOVOLEMIA_ALERT, 5, "Hypovolemia", "276.52", "Hypovolemia", "ICD9CM") if (is_met[0] or is_met[1]) and (is_met[2] or is_met[3])
    end

    def check_for_decreased_urinary_output patient
      guideline = Guideline.find_by_code("RENAL_DUO")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["duo_decreased_output"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step1, is_met[0], false)
      end

      GuidelineManager::update_step(step1, false, true) unless has_data[0]
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
        GuidelineManager::update_step(step1, is_met[0], false)
      end

      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_KIDNEY_INJURY_ALERT, 5, "Acute Kidney Injury", "584", "Acute kidney injury", "ICD9CM") if is_met[0]
    end

    def check_for_hyponatremia patient
      guideline = Guideline.find_by_code("RENAL_HPONT")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Serum sodium < 130
      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["serum_sodium", "2951-2"], pg, 0, Helper.any_code_exists_proc, hypon_serum_na_check)
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPONATREMIA_ALERT, 5, "Hyponatremia", "89627008", "Hyponatremia", "SNOMEDCT") if (is_met[0])
    end

    def check_for_hypernatremia patient
      guideline = Guideline.find_by_code("RENAL_HPRNT")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Serum sodium < 130
      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["serum_sodium", "2951-2"], pg, 0, Helper.any_code_exists_proc, hypern_serum_na_check)
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPERNATREMIA_ALERT, 5, "Hypernatremia", "39355002", "Hypernatremia", "SNOMEDCT") if is_met[0]
    end
  end
end