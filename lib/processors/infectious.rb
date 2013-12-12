module Processor
  class Infectious
    BODY_SYSTEM = 6

    # Alert type codes to uniquely identify each type of alert
    POSITIVE_BLOOD_CULTURE_ALERT = 60
    URINARY_TRACT_INFECTION_ALERT = 61
    POSITIVE_URINE_CULTURE_ALERT = 62
    POSITIVE_RESPIRATORY_CULTURE_ALERT = 63
    FEVER_ALERT = 64

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_positive_blood_culture patient
        check_for_urinary_tract_infection patient
        check_for_positive_urine_culture patient
        check_for_positive_respiratory_culture patient
        check_for_fever patient
      end
    end

    def check_for_positive_blood_culture patient
      # guideline = Guideline.find_by_code("INFECTIOUS_PBC")
      # return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      # pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      # step = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps.first.id, pg.id)

      # observations = patient.observations.find(:all, :conditions => ["code IN (?)", ["positive_blood_culture"]])
      # if observations.blank?
      #   puts "Patient guideline step requires data"
      #   step.update_attributes(:is_met => false, :requires_data => true)
      # else
      #   step.update_attributes(:is_met => true, :requires_data => false)
      #   if observations.any? { |obs| (obs.units == "mcg/mL" or obs.units.blank?) and obs.value.to_i > 2 }
      #     FIGURE OUT THE RIGHT CODES - MAY NEED TO HAVE 2 CODES DEPENDING IF IT'S SEPSIS OR BACTEREMIA
      #     GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_MI_ALERT, 5, "Positive blood culture (sepsis or bacteremia)", "22298006", "Myocardial infarction (disorder)", "SNOMEDCT")
      #   end
      # end
    end

    def check_for_urinary_tract_infection patient
    end

    def check_for_positive_urine_culture patient
    end

    def check_for_positive_respiratory_culture patient
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
        step1.update_attributes(:is_met => is_met[0], :requires_data => false)
      end

      step1.update_attributes(:is_met => false, :requires_data => true) unless has_data[0]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, FEVER_ALERT, 5, "Fever", "386661006", "Fever", "SNOMEDCT") if is_met[0]
    end
  end
end