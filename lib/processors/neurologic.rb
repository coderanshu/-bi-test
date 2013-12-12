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
        check_for_delerium patient
        check_for_alcohol_withdrawal patient
        check_for_altered_mental_status patient
      end
    end


    def check_for_delerium patient
      guideline = Guideline.find_by_code("NEUROLOGIC_DELERIUM")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["delerium_screening"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value == "Y") })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      observations = patient.observations.all(:conditions => ["code IN (?)", ["LP74647-6"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value == "POSITIVE" or obs.value == "POS") })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, DELIRIUM_ALERT, 5, "Delerium", "2776000", "Delerium", "SNOMEDCT") if is_met[0]
    end

    def check_for_alcohol_withdrawal patient
      guideline = Guideline.find_by_code("NEUROLOGIC_AW")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["ciwa_score"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value == "Y") })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ALCOHOL_WITHDRAWAL_ALERT, 5, "Alcohol Withdrawal", "291.81", "Alcohol withdrawal", "ICD9CM") if is_met[0]
    end

    def check_for_altered_mental_status patient
      guideline = Guideline.find_by_code("NEUROLOGIC_AMS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["glasgow_coma_decrease"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value == "Y") })
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      observations = patient.observations.all(:conditions => ["code IN (?)", ["glasgow_coma_scale", "glasgow_score", "386557006"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.select { |obs| (obs.value.to_i <= 8) }.size > 1)
        step1.update_attributes(:is_met => is_met, :requires_data => false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ALTERED_MENTAL_STATUS_ALERT, 5, "Altered Mental Status", "419284004", "Altered mental status", "SNOMEDCT") if is_met[0]
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ALTERED_MENTAL_STATUS_ALERT, 5, "Altered Mental Status", "419284004", "Altered mental status", "SNOMEDCT") if is_met[0]
    end
  end
end