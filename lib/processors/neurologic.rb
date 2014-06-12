module Processor
  class Neurologic
    BODY_SYSTEM = 1

    # Alert type codes to uniquely identify each type of alert
    DELIRIUM_ALERT = 10
    ALCOHOL_WITHDRAWAL_ALERT = 11
    ALTERED_MENTAL_STATUS_ALERT = 12

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_delirium patient
        check_for_alcohol_withdrawal patient
        check_for_altered_mental_status patient
      end
    end
    
    # Positive delirium screen
    def positive_delirium_check
      Proc.new do |observations|
        (observations.any? { |obs| (obs.value == "POSITIVE" or obs.value == "POS") })
      end
    end
    
    # Alcohol withdrawal check
    def alcohol_withdrawal_check
      Proc.new do |observations|
        (observations.any? { |obs| (obs.value.to_i >= 15)})
      end
    end
    
    def coma_baseline_check
      Proc.new do |observations|
        if (observations.blank? or observations.length < 2)
          false
        else
          observations = observations.sort_by { |x| [x.observed_on, x.id] }
          baseline = observations.first.value.to_i
          (observations.any? { |obs| (baseline - obs.value.to_i) >= 2})
        end
      end
    end
    
    def coma_threshold_check
      Proc.new do |observations|
        (observations.any? { |obs| (obs.value.to_i <= 8)})
      end
    end


    def check_for_delirium patient
      guideline = Guideline.find_by_code("NEUROLOGIC_DELIRIUM")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["delirium_screening"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["LP74647-6"], pg, 0, Helper.any_code_exists_proc, positive_delirium_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, DELIRIUM_ALERT, 5, "Delirium", "2776000", "Delirium", "SNOMEDCT") if (is_met[0] or is_met[1])
    end

    def check_for_alcohol_withdrawal patient
      guideline = Guideline.find_by_code("NEUROLOGIC_AW")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["ciwa_score", "445504001"], pg, 0, Helper.any_code_exists_proc, alcohol_withdrawal_check)
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0]), !(has_data[0]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ALCOHOL_WITHDRAWAL_ALERT, 5, "Alcohol Withdrawal", "291.81", "Alcohol withdrawal", "ICD9CM") if is_met[0]
    end

    def check_for_altered_mental_status patient
      guideline = Guideline.find_by_code("NEUROLOGIC_AMS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false]
      is_met = [false, false, false]
      
      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["glasgow_coma_decrease"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["glasgow_coma_scale", "glasgow_score", "386557006"], pg, 0, Helper.any_code_exists_proc, coma_baseline_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      has_data[2], is_met[2] = GuidelineManager::process_guideline_step(patient, ["glasgow_coma_scale", "glasgow_score", "386557006"], pg, 1, Helper.any_code_exists_proc, coma_threshold_check) unless (is_met[0] or is_met[1])
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[2]), !(has_data[2]))
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ALTERED_MENTAL_STATUS_ALERT, 5, "Altered Mental Status", "419284004", "Altered mental status", "SNOMEDCT") if (is_met[0] or is_met[1] or is_met[2])
    end
  end
end