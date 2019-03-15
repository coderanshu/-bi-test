module Processor
  class Renal
    BODY_SYSTEM = 5

    # Alert type codes to uniquely identify each type of alert
    HYPOVOLEMIA_ALERT = 50
    DECREASED_URINARY_OUTPUT_ALERT = 51
    ACUTE_KIDNEY_INJURY_ALERT = 52
    HYPONATREMIA_ALERT = 53
    HYPERNATREMIA_ALERT = 54
    GAP_ACIDEMIA_ALERT = 55
    ACIDEMIA_ALERT = 56
    ALKALEMIA_ALERT = 57

    SBP_THRESHOLD = 100
    CVP_THRESHOLD = 3
    HYPON_SERUM_NA_THRESHOLD = 130
    HYPERN_SERUM_NA_THRESHOLD = 150
    GAP_ACIDEMIA_THRESHOLD = 8
    ACIDEMIA_APH_THRESHOLD = 7.35
    ALKALEMIA_APH_THRESHOLD = 7.45
    CREATININE_THRESHOLD = 2.5


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
        check_for_gap_acidemia patient
        check_for_acidemia patient
        check_for_alkalemia patient
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

    # Na - (Chroride + HCO3) > 8
    def gap_acidemia_check
      Proc.new do |observations|
        sodium = observations[0]
        chloride = observations[1]
        hco3 = observations[2]
        unless sodium.blank? or chloride.blank? or hco3.blank?
          sodium_val = sodium.last.value
          chloride_val = chloride.last.value
          hco3_val = hco3.last.value
          if (sodium_val.blank? or chloride_val.blank? or hco3_val.blank?)
            false
          else
            ((sodium_val.to_i - (chloride_val.to_i + hco3_val.to_i)) > GAP_ACIDEMIA_THRESHOLD)
          end
        else
          false
        end
      end
    end

    # Arterial pH < 7.35
    def acidemia_aph_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.float_below_value(obs, ACIDEMIA_APH_THRESHOLD) })
      end
    end

    # Arterial pH > 7.45
    def alkalemia_aph_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.float_above_value(obs, ALKALEMIA_APH_THRESHOLD) })
      end
    end
    
    def creatinine_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.float_gt_eql_value(obs, CREATININE_THRESHOLD) })
      end
    end

    def check_for_hypovolemia patient
      guideline = Guideline.find_by_code("RENAL_HVLM")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false, false]
      is_met = [false, false, false, false]
      relevant_observations = [nil, nil, nil, nil]

      # First, check for low central venous pressure
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["hvlm_low_pressure"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1], relevant_observations[1] = GuidelineManager::process_guideline_step(patient, ["CVP", "71420008"], pg, 0, Helper.any_code_exists_proc, central_venous_pressure_check) unless is_met[0]

      observations = Hash.new
      observations["Low central venous pressure?"] = relevant_observations[0]
      observations["Central Venous Pressure"] = relevant_observations[1]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]), observations)

      # Next, check for low SBP
      has_data[2], is_met[2], relevant_observations[2] = GuidelineManager::process_guideline_step(patient, ["hvlm_low_sbp"], pg, 1, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[3], is_met[3], relevant_observations[3] = GuidelineManager::process_guideline_step(patient, ["systolic_bp", "SBP", "8480-6"],
        pg, 1, Helper.any_code_exists_proc, systolic_bp_check) unless is_met[2]

      observations = Hash.new
      observations["Low Systolic BP"] = relevant_observations[2]
      observations["Systolic BP"] = relevant_observations[3]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[2] or is_met[3]), !(has_data[2] or has_data[3]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPOVOLEMIA_ALERT, 5, "Hypovolemia", "276.52", "Hypovolemia", "ICD9CM") if (is_met[0] or is_met[1]) and (is_met[2] or is_met[3])
    end

    def check_for_decreased_urinary_output patient
      guideline = Guideline.find_by_code("RENAL_DUO")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["duo_decreased_output"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)

      observations = Hash.new
      observations["Decreased Urinary Output?"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !(has_data[0]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, DECREASED_URINARY_OUTPUT_ALERT, 5, "Decreased Urinary Output", "788.5", "Oliguria", "ICD9CM") if is_met[0]
    end

    def check_for_acute_kidney_injury patient
      guideline = Guideline.find_by_code("RENAL_AKI")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]
      
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["creatinine", "2161-8"], pg, 0, Helper.any_code_exists_proc, creatinine_check)

      observations = Hash.new
      observations["Creatinine"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_KIDNEY_INJURY_ALERT, 5, "Acute Kidney Injury", "584", "Acute kidney injury", "ICD9CM") if is_met[0]
    end

    def check_for_hyponatremia patient
      guideline = Guideline.find_by_code("RENAL_HPONT")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      # Serum sodium < 130
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["serum_sodium", "2951-2"], pg, 0, Helper.any_code_exists_proc, hypon_serum_na_check)

      observations = Hash.new
      observations["Serum Sodium"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPONATREMIA_ALERT, 5, "Hyponatremia", "89627008", "Hyponatremia", "SNOMEDCT") if (is_met[0])
    end

    def check_for_hypernatremia patient
      guideline = Guideline.find_by_code("RENAL_HPRNT")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      # Serum sodium < 130
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["serum_sodium", "2951-2"], pg, 0, Helper.any_code_exists_proc, hypern_serum_na_check)

      observations = Hash.new
      observations["Serum Sodium"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPERNATREMIA_ALERT, 5, "Hypernatremia", "39355002", "Hypernatremia", "SNOMEDCT") if is_met[0]
    end

    def check_for_gap_acidemia patient
      guideline = Guideline.find_by_code("RENAL_GAP_ACIDEMIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      # Na - (Chroride + HCO3) > 8
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, [["serum_sodium", "2951-2"], ["serum_chloride", "2075-0"], ["HCO3", "1963-8"]], pg, 0, Helper.latest_code_exists_proc, gap_acidemia_check)

      observations = Hash.new
      unless relevant_observations[0].nil?
        observations["Serum Na"] = relevant_observations[0][0]
        observations["Serum Cl"] = relevant_observations[0][1]
        observations["HCO3"] = relevant_observations[0][2]
      end
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, GAP_ACIDEMIA_ALERT, 5, "Gap acidemia", "237854004", "Gap acidemia", "SNOMEDCT") if is_met[0]
    end

    def check_for_acidemia patient
      guideline = Guideline.find_by_code("RENAL_ACIDEMIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      # Arterial pH < 7.35
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["arterial_ph", "ApH", "2746-6"], pg, 0, Helper.any_code_exists_proc, acidemia_aph_check)

      observations = Hash.new
      observations["Arterial pH"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACIDEMIA_ALERT, 5, "Acidemia", "70731005", "Acidemia", "SNOMEDCT") if is_met[0]
    end

    def check_for_alkalemia patient
      guideline = Guideline.find_by_code("RENAL_ALKALEMIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      # Arterial pH > 7.45
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["arterial_ph", "ApH", "2746-6"], pg, 0, Helper.any_code_exists_proc, alkalemia_aph_check)

      observations = Hash.new
      observations["Arterial pH"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ALKALEMIA_ALERT, 5, "Alkalemia", "79169000", "Alkalemia", "SNOMEDCT") if is_met[0]
    end
  end
end