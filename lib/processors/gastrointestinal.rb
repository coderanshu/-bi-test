module Processor
  class Gastrointestinal
    BODY_SYSTEM = 4

    # Alert type codes to uniquely identify each type of alert
    LIVER_DISFUNCTION_ALERT = 40
    PANCREATITIS_ALERT = 41
    CHOLECYSTITIS_ALERT = 42
    MALNUTRITION_ALERT = 43

    AST_FEMALE_THRESHOLD = 102
    AST_MALE_THRESHOLD = 120
    ALT_FEMALE_THRESHOLD = 102
    ALT_MALE_THRESHOLD = 135
    HIGH_AMYLASE_THRESHOLD = 255
    HIGH_ALK_PHOS_THRESHOLD = 420
    LOW_ALBUMIN_THRESHOLD = 2.0

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_liver_disfunction patient
        check_for_pancreatitis patient
        check_for_cholecystitis patient
        check_for_malnutrition patient
      end
    end

    # AST outside of high range
    def high_ast_check
      Proc.new do |observations|
        patient = observations.first.patient
        if patient.gender == "F"
          (observations.select { |obs| Helper.int_above_value(obs, AST_FEMALE_THRESHOLD) }.size >= 1)  # 3x female high range (34 * 3)
        else
          (observations.select { |obs| Helper.int_above_value(obs, AST_MALE_THRESHOLD) }.size >= 1)  # 3x male high range (40 * 3)
        end
      end
    end

    # ALT outside of high range
    def high_alt_check
      Proc.new do |observations|
        patient = observations.first.patient
        if patient.gender == "F"
          (observations.select { |obs| Helper.int_above_value(obs, ALT_FEMALE_THRESHOLD) }.size >= 1)  # 3x female high range (34 * 3)
        else
          (observations.select { |obs| Helper.int_above_value(obs, ALT_MALE_THRESHOLD) }.size >= 1)  # 3x male high range (45 * 3)
        end
      end
    end

    # 3x high range (85) amylase
    def high_amylase_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_above_value(obs, HIGH_AMYLASE_THRESHOLD) }.size >= 1)
      end
    end

    # 3x high range (140) alkaline phosphatase
    def high_alk_phos_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_above_value(obs, HIGH_ALK_PHOS_THRESHOLD) }.size >= 1)
      end
    end

    # Low albumin
    def low_albumin_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.float_below_value(obs, LOW_ALBUMIN_THRESHOLD) }.size >= 1)
      end
    end

    def check_for_liver_disfunction patient
      guideline = Guideline.find_by_code("GI_LD")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]
      relevant_observations = [nil, nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["AST", "1920-8"], pg, 0, Helper.any_code_exists_proc, high_ast_check)
      observations = Hash.new
      observations["AST"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)

      has_data[1], is_met[1], relevant_observations[1] = GuidelineManager::process_guideline_step(patient, ["ALT", "1742-6"], pg, 1, Helper.any_code_exists_proc, high_alt_check)
      observations = Hash.new
      observations["ALT"] = relevant_observations[1]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[1]), !(has_data[1]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, LIVER_DISFUNCTION_ALERT, 5, "Liver dysfunction", "XXXXXX", "Liver dysfunction", "SNOMEDCT") if (is_met[0] or is_met[1])
    end


    def check_for_pancreatitis patient
      guideline = Guideline.find_by_code("GI_PANCREATITIS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["amylase", "1805-1"], pg, 0, Helper.any_code_exists_proc, high_amylase_check)
      observations = Hash.new
      observations["Amylase"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, PANCREATITIS_ALERT, 5, "Pancreatitis", "75694006", "Pancreatitis", "SNOMEDCT") if is_met[0]
    end

    def check_for_cholecystitis patient
      guideline = Guideline.find_by_code("GI_CHOLECYSTITIS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["ALP", "alkaline_phosphatase", "6768-6"], pg, 0, Helper.any_code_exists_proc, high_alk_phos_check)
      observations = Hash.new
      observations["Alkaline Phosphatase"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, CHOLECYSTITIS_ALERT, 5, "Cholecystitis", "76581006", "Cholecystitis", "SNOMEDCT") if is_met[0]
    end

    def check_for_malnutrition patient
      # albumin < 2 mg/dL, or no nutrition (tube feeds or parenteral nutrition) for three days
      guideline = Guideline.find_by_code("GI_MALNUTRITION")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]
      relevant_observations = [nil, nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["ALB", "albumin", "2862-1"], pg, 0, Helper.any_code_exists_proc, low_albumin_check)
      observations = Hash.new
      observations["Albumin"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]), observations)

      has_data[1], is_met[1], relevant_observations[1] = GuidelineManager::process_guideline_step(patient, ["no_nutrition_3_days"], pg, 1, Helper.any_code_exists_proc, Helper.observation_yes_check)
      observations = Hash.new
      observations["No Nutrition 3 Days"] = relevant_observations[1]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[1]), !(has_data[1]), observations)

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, MALNUTRITION_ALERT, 5, "Malnutrition", "XXXXXX", "Malnutrition", "SNOMEDCT") if (is_met[0] or is_met[1])
    end
  end
end