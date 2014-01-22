module Processor
  class Respiratory
    BODY_SYSTEM = 2

    # Alert type codes to uniquely identify each type of alert
    PULMONARY_EMBOLISM_CONCERN_ALERT = 20
    ACUTE_LUNG_INJURY_CONCERN_ALERT = 21
    READINESS_OF_VENTILATOR_WEANING_ALERT = 22
    VENTILATOR_ASSOCIATED_CONDITION_ALERT = 23

    HR_THRESHOLD = 100
    APCO2_THRESHOLD = 50
    APH_THRESHOLD = 7.45
    PARTIAL_PRESSURE_THRESHOLD = 300.0
    INSPIRED_O2_THRESHOLD = 0.4
    PLATEAU_PRESSURE_THRESHOLD = 5

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_pulmonary_embolism_concern patient
        check_for_acute_lung_injury_concern patient
        check_for_readiness_of_ventilator_weaning patient
        check_for_vac patient
      end
    end

    # More than 2 readings or two consecutive readings of HR > 100
    def high_heart_rate_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_above_value(obs, HR_THRESHOLD) }.size > 2) ?
          true : Helper.consecutive_int_above_value(observations, HR_THRESHOLD)
      end
    end

    # Arterial pCO2 > 50 and pH >7.45
    def alkalosis_check
      Proc.new do |observations|
        apco2 = observations[0]
        aph = observations[1]
        unless apco2.blank? or aph.blank?
          (observations[0].any? { |obs| Helper.int_above_value(obs, APCO2_THRESHOLD) }) and
            (observations[1].any? { |obs| Helper.float_above_value(obs, APH_THRESHOLD) })
        else
          false
        end
      end
    end

    def plateau_pressure_check
      Proc.new do |observations|
        (observations.select { |obs| Helper.int_above_value(obs, PLATEAU_PRESSURE_THRESHOLD) }.size > 1)
      end
    end

    def pressure_support_check
      Proc.new do |observations|
        (observations.select { |obs| !obs.value.blank? }.size > 1)
      end
    end

    def fraction_o2_check
      Proc.new do |observations|
        #(observations.select { |obs| Helper.consecutive_float_above_value_in_time_window(obs, INSPIRED_O2_THRESHOLD, 2 * 60) }.size > 1)
        Helper.consecutive_float_above_value_in_time_window(observations, INSPIRED_O2_THRESHOLD, 2 * 60)
      end
    end

    # Partial pressure of oxygen divided by fraction of inspired oxygen < 300. (often abbreviated as PaO2/FiO2)
    def partial_pressure_threshold_check
      Proc.new do |observations|
        paO2 = observations[0]
        fiO2 = observations[1]
        unless paO2.blank? or fiO2.blank?
          paO2_value = paO2.last.value.to_f
          fiO2_value = fiO2.last.value.to_f
          ((paO2_value / fiO2_value) < PARTIAL_PRESSURE_THRESHOLD)
        else
          false
        end
      end
    end

    def tidal_volume_check
      Proc.new do |observations|
        height = observations[0]
        tidal_vol = observations[1]
        unless height.blank? or tidal_vol.blank?
          height_value = height.last.value.to_f
          tidal_vol_value = tidal_vol.last.value.to_i
          # Calculate ideal weight based on Devine formula (50.0 + 2.3 kg per inch over 5 feet)
          height_inches = height_value * 0.393701
          devine_weight = 50.0 + (2.3 * (height_inches - 60))
          (((tidal_vol_value * 1.0) / devine_weight) >= 8.0)
        else
          false
        end
      end
    end

    def check_for_pulmonary_embolism_concern patient
      guideline = Guideline.find_by_code("RESPIRATORY_PEC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false, false]
      is_met = [false, false, false, false]

      # First, check for high heart rate
      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["two_high_heart_rate_100"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["heart_rate", "HR", "LP32063-7"], pg, 0, Helper.any_code_exists_proc, high_heart_rate_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      # Next, check for new respiratory alkalosis
      has_data[2], is_met[2] = GuidelineManager::process_guideline_step(patient, ["new_respiratory_alkalosis"], pg, 1, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[3], is_met[3] = GuidelineManager::process_guideline_step(patient, [["arterial_pco2", "ApCO2", "33022-5"], ["arterial_ph", "ApH", "2746-6"]],
        pg, 1, Helper.any_code_exists_proc, alkalosis_check) unless is_met[2]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[2] or is_met[3]), !(has_data[2] or has_data[3]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, PULMONARY_EMBOLISM_CONCERN_ALERT, 5, "Pulmonary Embolism Concern", "59282003", "Pulmonary Embolism", "SNOMEDCT") if (is_met[0] or is_met[1]) and (is_met[2] or is_met[3])
    end

    def check_for_acute_lung_injury_concern patient
      guideline = Guideline.find_by_code("RESPIRATORY_ALIC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false, false, false, false]
      is_met = [false, false, false, false, false, false]

      # Check if partial pressure below threshold
      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["oxygen_ratio_below_300"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, [["paO2", "3148-4"], ["fiO2", "19994-3"]],
        pg, 0, Helper.latest_code_exists_proc, partial_pressure_threshold_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      # Exists confirmation chest x-ray
      has_data[2], is_met[2] = GuidelineManager::process_guideline_step(patient, ["alic_confirmed_chest_radiograph"], pg, 1, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), is_met[2], !has_data[2])

      # Tidal volume
      has_data[3], is_met[3] = GuidelineManager::process_guideline_step(patient, ["alic_tidal_volume"], pg, 2, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[4], is_met[4] = GuidelineManager::process_guideline_step(patient, [["height", "LP64598-3"], ["tidal_vol", "tidal_volume", "20112-9"]],
        pg, 2, Helper.latest_code_exists_proc, tidal_volume_check) unless is_met[3]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 2), (is_met[3] or is_met[4]), !(has_data[3] or has_data[4]))

      # Ventilator setting appropriate
      has_data[5], is_met[5] = GuidelineManager::process_guideline_step(patient, ["alic_ventilation_appropriate"], pg, 3, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 3), is_met[5], !has_data[5])

      if (is_met[0] or is_met[1]) and is_met[2] and (is_met[3] or is_met[4]) and is_met[5]
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_LUNG_INJURY_CONCERN_ALERT, 5, "Acute Lung Injury Concern", "315345002", "Acute Lung Injury", "SNOMEDCT")
      elsif (is_met[0] or is_met[1]) and (is_met[3] or is_met[4]) and !has_data[2] and !has_data[5]
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_LUNG_INJURY_CONCERN_ALERT, 3, "Trending towards Acute Lung Injury Concern", "315345002", "Trending towards Acute Lung Injury", "SNOMEDCT")
      end
    end

    def check_for_readiness_of_ventilator_weaning patient
      guideline = Guideline.find_by_code("RESPIRATORY_ROVW")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false, false, false, false]
      is_met = [false, false, false, false, false, false]

      # On pressure support mode
      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["rovw_pressure_support_mode"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["19834-1"], pg, 0, Helper.latest_code_exists_proc, pressure_support_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      # Check plateau pressure
      has_data[2], is_met[2] = GuidelineManager::process_guideline_step(patient, ["rovw_h2o"], pg, 1, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[3], is_met[3] = GuidelineManager::process_guideline_step(patient, ["plateau_pressure", "LP94729-8"], pg, 1, Helper.latest_code_exists_proc, plateau_pressure_check) unless is_met[2]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[2] or is_met[3]), !(has_data[2] or has_data[3]))

      # Fraction of inspired oxygen
      has_data[4], is_met[4] = GuidelineManager::process_guideline_step(patient, ["rovw_fraction_o2"], pg, 2, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[5], is_met[5] = GuidelineManager::process_guideline_step(patient, ["19994-3"], pg, 2, Helper.latest_code_exists_proc, fraction_o2_check) unless is_met[4]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[4] or is_met[5]), !(has_data[4] or has_data[5]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, READINESS_OF_VENTILATOR_WEANING_ALERT, 5, "Readiness of Ventilator Weaning", nil, nil, nil) if (is_met[0] or is_met[1]) and (is_met[2] or is_met[3]) and (is_met[4] or is_met[5])
    end

    def check_for_vac patient
      guideline = Guideline.find_by_code("RESPIRATORY_VAC_CDC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false, false, false]
      is_met = [false, false, false, false, false]

      step1 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[0].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["vac_ventilator_days"]])
      unless observations.blank?
        has_data[0] = true
        is_met[0] = (observations.any? { |obs| (obs.value.to_i >= 3) })
        GuidelineManager::update_step(step1, is_met[0], false)
      end

      step2 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[1].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["fio2_increase_days"]])
      unless observations.blank?
        has_data[1] = true
        is_met[1] = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step2, is_met[1], false)
      end

      step3 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[2].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["temperature", "LP29701-7"]])
      unless observations.blank?
        has_data[2] = true
        is_met[2] = (observations.any? { |obs| (obs.value.to_f > 100.4 or obs.value.to_f < 96.8) })
        GuidelineManager::update_step(step3, is_met[2], false)
      end

      step4 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[3].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["on_antimicro_agent"]])
      unless observations.blank?
        has_data[3] = true
        is_met[3] = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step4, is_met[3], false)
      end

      step5 = PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(guideline.guideline_steps[4].id, pg.id)
      observations = patient.observations.all(:conditions => ["code IN (?)", ["vac_purulent_secretions"]])
      unless observations.blank?
        has_data[4] = true
        is_met[4] = (observations.any? { |obs| (obs.value == "Y") })
        GuidelineManager::update_step(step5, is_met[4], false)
      end

      GuidelineManager::update_step(step1, false, true) unless has_data[0]
      GuidelineManager::update_step(step2, false, true) unless has_data[1]
      GuidelineManager::update_step(step3, false, true) unless has_data[2]
      GuidelineManager::update_step(step4, false, true) unless has_data[3]
      GuidelineManager::update_step(step5, false, true) unless has_data[4]
      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, VENTILATOR_ASSOCIATED_CONDITION_ALERT, 5, "Ventilator Associated Condition", "429271009", "Ventilator-acquired pneumonia", "SNOMEDCT") if is_met[0] and is_met[1] and is_met[2] and is_met[3] and is_met[4]
    end
  end
end