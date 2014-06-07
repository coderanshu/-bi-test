module Processor
  class Cardiac
    BODY_SYSTEM = 3

    # Alert type codes to uniquely identify each type of alert
    ACUTE_MI_ALERT = 30
    #ABNORMAL_HIGH_FUNCTION_ALERT = 31
    #ABNORMAL_LOW_FUNCTION_ALERT = 32
    MALIGNANT_HYPERTENSION_ALERT = 33
    TACHYCARDIA_ALERT = 34
    HYPOTENSION_ALERT = 35
    BRADYCARDIA_ALERT = 36
    WEIGHT_CHANGE_ALERT = 37

    TROPONIN_THRESHOLD = 2.0
    HIGH_SBP_THRESHOLD = 200
    HIGH_HR_THRESHOLD = 150
    LOW_SBP_THRESHOLD = 90
    LOW_HR_THRESHOLD = 40
    WEIGHT_CHANGE_THRESHOLD = 10.0

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_acute_myocardial_infarction patient
        check_for_malignant_hypertension patient
        check_for_tachycardia patient
        check_for_hypotension patient
        check_for_bradycardia patient
        check_for_weight_change patient
      end
    end

    # A single Cardiac Troponin I > 2
    def troponin_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.float_above_value(obs, TROPONIN_THRESHOLD) }.size >= 1)
      end
    end

    # Two or more systolic BP > 200
    def high_sbp_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_above_value(obs, HIGH_SBP_THRESHOLD) }.size >= 2)
      end
    end

    # A single HR > 150
    def high_hr_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_above_value(obs, HIGH_HR_THRESHOLD) }.size >= 2)
      end
    end

    # Two or more systolic BP < 90
    def low_sbp_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_below_value(obs, LOW_SBP_THRESHOLD) }.size >= 2)
      end
    end

    # A single HR < 40
    def low_hr_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_below_value(obs, LOW_HR_THRESHOLD) }.size >= 2)
      end
    end

    # Admission weight - current weight
    def weight_change_check
      Proc.new do |observations|
        Helper.float_difference_above_value(observations.order('observed_on, id'), WEIGHT_CHANGE_THRESHOLD)
      end
    end


    def check_for_acute_myocardial_infarction patient
      guideline = Guideline.find_by_code("CARDIAC_AMI")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["CTI", "cardiac_troponin_i", "10839-9"], pg, 0, Helper.latest_code_exists_proc, troponin_check)
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]))
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_MI_ALERT, 5, "Acute myocardial infarction", "22298006", "Myocardial infarction (disorder)", "SNOMEDCT") if (is_met[0])
    end

    def check_for_malignant_hypertension patient
      guideline = Guideline.find_by_code("CARDIAC_HYPERTENSION")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["two_high_systolic_bp"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["systolic_bp", "SBP", "8480-6"], pg, 0, Helper.any_code_exists_proc, high_sbp_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, MALIGNANT_HYPERTENSION_ALERT, 5, "Hypertension, malignant", "70272006", "Hypertension, malignant", "SNOMEDCT") if (is_met[0] or is_met[1])
    end

    def check_for_tachycardia patient
      guideline = Guideline.find_by_code("CARDIAC_TACHYCARDIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["two_high_heart_rate"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["heart_rate", "HR", "LP32063-7"], pg, 0, Helper.any_code_exists_proc, high_hr_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, TACHYCARDIA_ALERT, 5, "Tachycardia", "3424008", "Tachycardia", "SNOMEDCT") if (is_met[0] or is_met[1])
    end

    def check_for_hypotension patient
      guideline = Guideline.find_by_code("CARDIAC_HYPOTENSION")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["two_low_systolic_bp"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["systolic_bp", "SBP", "8480-6"], pg, 0, Helper.any_code_exists_proc, low_sbp_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HYPOTENSION_ALERT, 5, "Hypotension", "45007003", "Low blood pressure", "SNOMEDCT") if (is_met[0] or is_met[1])
    end

    def check_for_bradycardia patient
      guideline = Guideline.find_by_code("CARDIAC_BRADYCARDIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["two_low_heart_rate"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["heart_rate", "HR", "LP32063-7"], pg, 0, Helper.any_code_exists_proc, low_hr_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, BRADYCARDIA_ALERT, 5, "Bradycardia", "48867003", "Bradycardia", "SNOMEDCT") if (is_met[0] or is_met[1])
    end

    def check_for_weight_change patient
      guideline = Guideline.find_by_code("CARDIAC_WEIGHT_CHANGE")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["weight_change"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["weight", "Wt", "272102008"], pg, 0, Helper.any_code_exists_proc, weight_change_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, WEIGHT_CHANGE_ALERT, 5, "Weight change", "", "Weight change", "SNOMEDCT") if (is_met[0] or is_met[1])
    end
  end
end
