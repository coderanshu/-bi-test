module Processor
  class Hematology
    BODY_SYSTEM = 7

    # Alert type codes to uniquely identify each type of alert
    HEMOGLOBIN_ABNORMAL_LOW_ALERT = 70
    PLATELETS_ABNORMAL_LOW_ALERT = 71
    LOW_NEUTROPHIL_ALERT = 72

    LOW_HEMOGLOBIN_THRESHOLD = 7.0
    LOW_PLATELET_THRESHOLD = 50
    LOW_NEUTROPHIL_THRESHOLD = 500.0

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_low_hemoglobin patient
        check_for_low_platelets patient
        check_for_low_neutrophil patient
      end
    end

    # Hemoglobin <= 7.0
    def low_hemoglobin_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.float_lt_eql_value(obs, LOW_HEMOGLOBIN_THRESHOLD) })
      end
    end

    # Platelets < 50
    def low_platelet_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.int_below_value(obs, LOW_PLATELET_THRESHOLD) })
      end
    end

    # Calculated neutrophil count <= 500.0
    def neutrophil_check
      Proc.new do |observations|
        wbc = observations[0]
        pct_neutrophils = observations[1]
        pct_bands = observations[2]
        unless wbc.blank? or pct_neutrophils.blank? or pct_bands.blank?
          if wbc.last.value.blank? or pct_neutrophils.last.value.blank? or pct_bands.last.value.blank?
            false
          else
            ((pct_neutrophils.last.value.to_f + pct_bands.last.value.to_f) * wbc.last.value.to_f) <= LOW_NEUTROPHIL_THRESHOLD
          end
        else
          false
        end
      end
    end

    def check_for_low_hemoglobin patient
      guideline = Guideline.find_by_code("HEMATOLOGY_ALHGB")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["HGB", "hemoglobin", "4635-9"], pg, 0, Helper.any_code_exists_proc, low_hemoglobin_check)
      observations = Hash.new
      observations["Hemoglobin"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !has_data[0], observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, HEMOGLOBIN_ABNORMAL_LOW_ALERT, 5, "Anemia", "271737000", "Anemia (Low hemoglobin)", "SNOMEDCT") if is_met[0]
    end

    def check_for_low_platelets patient
      guideline = Guideline.find_by_code("HEMATOLOGY_ALP")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false]
      is_met = [false]
      relevant_observations = [nil]

      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["platelets", "26515-7"], pg, 0, Helper.any_code_exists_proc, low_platelet_check)
      observations = Hash.new
      observations["Platelets"] = relevant_observations[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), is_met[0], !has_data[0], observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, PLATELETS_ABNORMAL_LOW_ALERT, 5, "Heparin-induced thrombocytopenia", "XXXXXX", "Heparin-induced thrombocytopenia", "SNOMEDCT") if is_met[0]
    end

    def check_for_low_neutrophil patient
      guideline = Guideline.find_by_code("HEMATOLOGY_ALNC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]
      relevant_observations = [nil, nil]

      # Check if partial pressure below threshold
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["abnormal_low_neutrophil_count"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1], relevant_observations[1] = GuidelineManager::process_guideline_step(patient, [["WBC", "26464-8"], ["pct_neutrophils"], ["pct_bands"]],
        pg, 0, Helper.latest_code_exists_proc, neutrophil_check) unless is_met[0]

      observations = Hash.new
      observations["Abnormally low neutrophils?"] = relevant_observations[0]
      unless relevant_observations[1].nil?
        observations["WBC"] = relevant_observations[1][0]
        observations["% Neutrophils"] = relevant_observations[1][1]
        observations["% Bands"] = relevant_observations[1][2]
      end
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]), observations)
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, LOW_NEUTROPHIL_ALERT, 5, "Abnormal low neutrophils", "XXXXXX", "Abnormal low neutrophils", "SNOMEDCT") if (is_met[0] or is_met[1])
    end
  end
end