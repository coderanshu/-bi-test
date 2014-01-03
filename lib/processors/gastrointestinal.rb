module Processor
  class Gastrointestinal
    BODY_SYSTEM = 4

    # Alert type codes to uniquely identify each type of alert
    LIVER_DISFUNCTION_ALERT = 40
    PANCREATITIS_ALERT = 41
    CHOLECYSTITIS_ALERT = 42
    MALNUTRITION_ALERT = 43

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

    def check_for_liver_disfunction patient
      guideline = Guideline.find_by_code("GI_LD")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]

      # Check for high AST (aspartate aminotransferase)
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["AST", "1920-8"]])
      unless observations.blank?
        has_data[0] = true
        if patient.gender == "F"
          found_obs = (observations.select { |obs| (obs.value.to_i > 102) }).first  # 3x female high range (34 * 3)
        else
          found_obs = (observations.select { |obs| (obs.value.to_i > 120) }).first  # 3x male high range (40 * 3)
        end
        is_met = !found_obs.blank?
        step1.update_attributes(:is_met => is_met, :requires_data => false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, LIVER_DISFUNCTION_ALERT, 5, "Liver dysfunction", "XXXXXX", "Liver dysfunction", "SNOMEDCT") if is_met
      end

      # Check for high ALT (alanine aminotransferase)
      step2 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[1].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["ALT", "1742-6"]])
      unless observations.blank?
        has_data[1] = true
        if patient.gender == "F"
          found_obs = (observations.select { |obs| (obs.value.to_i > 102) }).first  # 3x female high range (34 * 3)
        else
          found_obs = (observations.select { |obs| (obs.value.to_i > 135) }).first  # 3x male high range (45 * 3)
        end
        is_met = !found_obs.blank?
        step2.update_attributes(:is_met => is_met, :requires_data => false)
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, LIVER_DISFUNCTION_ALERT, 5, "Liver dysfunction", "XXXXXX", "Liver dysfunction", "SNOMEDCT") if is_met
      end

      puts "Patient guideline step requires data"
      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      step2.update_attributes(:is_met => false, :requires_data => true) unless has_data[1]
    end


    def check_for_pancreatitis patient
      guideline = Guideline.find_by_code("GI_PANCREATITIS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Check for amylase at least twice the upper limit of normal
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["amylase", "1805-1"]])
      unless observations.blank?
        has_data[0] = true
        found_obs = (observations.select { |obs| (obs.value.to_f > 180) }).first
        is_met[0] = !found_obs.blank?
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, PANCREATITIS_ALERT, 5, "Pancreatitis", "75694006", "Pancreatitis", "SNOMEDCT") if is_met[0]
    end

    def check_for_cholecystitis patient
      guideline = Guideline.find_by_code("GI_CHOLECYSTITIS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]

      # Check for alkaline phosphatase at least twice the upper limit of normal
      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["ALP", "alkaline_phosphatase", "1805-1"]])
      unless observations.blank?
        has_data[0] = true
        found_obs = (observations.select { |obs| (obs.value.to_f > 300) }).first
        is_met[0] = !found_obs.blank?
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, PANCREATITIS_ALERT, 5, "Cholecystitis", "76581006", "Cholecystitis", "SNOMEDCT") if is_met[0]
    end

    def check_for_malnutrition patient
      # albumin < 2 mg/dL, or no nutrition (tube feeds or parenteral nutrition) for three days
    end
  end
end