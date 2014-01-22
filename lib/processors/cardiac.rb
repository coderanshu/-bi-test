module Processor
  class Cardiac
    BODY_SYSTEM = 3

    # Alert type codes to uniquely identify each type of alert
    ACUTE_MI_ALERT = 30
    ABNORMAL_HIGH_FUNCTION_ALERT = 31
    ABNORMAL_LOW_FUNCTION_ALERT = 32

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_acute_myocardial_infarction patient
        check_for_abnormal_high_function patient
        check_for_abnormal_low_function patient
      end
    end

    def check_for_acute_myocardial_infarction patient
      guideline = Guideline.find_by_code("CARDIAC_AMI")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      step = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps.first.id, pg.id)

      observations = patient.observations.find(:all, :conditions => ["code IN (?)", ["CTI", "cardiac_troponin_i"]])
      if observations.blank?
        puts "Patient guideline step requires data"
        GuidelineManager::update_step(step, false, true)
      else
        step.update_attributes(:requires_data => false)
        if observations.any? { |obs| (obs.units == "mcg/mL" or obs.units.blank?) and obs.value.to_i > 2 }
          GuidelineManager::update_step(step, true, nil)
          GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_MI_ALERT, 5, "Acute myocardial infarction", "22298006", "Myocardial infarction (disorder)", "SNOMEDCT")
        end
      end
    end

    def check_for_abnormal_high_function patient
      guideline = Guideline.find_by_code("CARDIAC_AHF")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]

      # First, check for high systolic BP
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["two_high_systolic_bp"]])
      unless observations.blank?
        has_data[0] = true
        is_met = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step1, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_HIGH_FUNCTION_ALERT, 5, "Abnormal High Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      observations = patient.observations.all(:conditions => ["code IN (?)", ["systolic_bp", "SBP", "8480-6"]])
      unless observations.blank?
        has_data[0] = true
        is_met = (observations.select { |obs| (obs.value.to_i > 200) }.size > 1)
        GuidelineManager::update_step(step1, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_HIGH_FUNCTION_ALERT, 5, "Abnormal High Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      # Next, check for high heart rate
      step2 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[1].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["two_high_heart_rate"]])
      unless observations.blank?
        has_data[1] = true
        is_met = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step2, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_HIGH_FUNCTION_ALERT, 5, "Abnormal High Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      observations = patient.observations.all(:conditions => ["code IN (?)", ["heart_rate", "HR", "LP32063-7"]])
      unless observations.blank?
        has_data[1] = true
        is_met = (observations.select { |obs| (obs.value.to_i > 150) }.size > 1)
        GuidelineManager::update_step(step2, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_HIGH_FUNCTION_ALERT, 5, "Abnormal High Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      puts "Patient guideline step requires data"
      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      GuidelineManager::update_step(step2, false, true) unless has_data[1]
    end

    def check_for_abnormal_low_function patient
      guideline = Guideline.find_by_code("CARDIAC_ALF")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]

      # First, check for low systolic BP
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["two_low_systolic_bp"]])
      unless observations.blank?
        has_data[0] = true
        is_met = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step1, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_LOW_FUNCTION_ALERT, 5, "Abnormal Low Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      observations = patient.observations.all(:conditions => ["code IN (?)", ["systolic_bp", "SBP", "8480-6"]])
      unless observations.blank?
        has_data[0] = true
        is_met = (observations.select { |obs| (obs.value.to_i < 90) }.size > 1)
        GuidelineManager::update_step(step1, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_LOW_FUNCTION_ALERT, 5, "Abnormal Low Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      # Next, check for low heart rate
      step2 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[1].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["two_low_heart_rate"]])
      unless observations.blank?
        has_data[1] = true
        is_met = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step2, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_LOW_FUNCTION_ALERT, 5, "Abnormal Low Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      observations = patient.observations.all(:conditions => ["code IN (?)", ["heart_rate", "HR", "LP32063-7"]])
      unless observations.blank?
        has_data[1] = true
        is_met = (observations.select { |obs| (obs.value.to_i < 40) }.size > 1)
        GuidelineManager::update_step(step2, is_met, false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ABNORMAL_LOW_FUNCTION_ALERT, 5, "Abnormal Low Function", "38936003", "Abnormal blood pressure (finding)", "SNOMEDCT") if is_met
      end

      puts "Patient guideline step requires data"
      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      GuidelineManager::update_step(step2, false, true) unless has_data[1]
    end
  end
end
