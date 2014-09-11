module Processor
  class Respiratory
    BODY_SYSTEM = 2

    # Alert type codes to uniquely identify each type of alert
    PULMONARY_EMBOLISM_CONCERN_ALERT = 20
    #ACUTE_LUNG_INJURY_CONCERN_ALERT = 21
    READINESS_OF_VENTILATOR_WEANING_ALERT = 22
    VENTILATOR_ASSOCIATED_CONDITION_ALERT = 23
    ACUTE_RESPIRATORY_DISTRESS_ALERT = 24
    PNEUMONIA_ALERT = 25

    HR_THRESHOLD = 100
    APCO2_THRESHOLD = 50
    APH_THRESHOLD = 7.45
    PARTIAL_PRESSURE_THRESHOLD = 300.0
    INSPIRED_O2_THRESHOLD = 0.4
    PLATEAU_PRESSURE_THRESHOLD = 5
    BRONCHIAL_LAVAGE_CFU_THRESHOLD = 1000

    TIDAL_VOLUME_DEFAULT_MESSAGE = ''

    def initialize(patients)
      @patients = patients
    end

    def execute()
      return if @patients.blank?
      @patients.each do |patient|
        check_for_pulmonary_embolism_concern patient
        check_for_acute_respiratory_distress patient
        check_for_readiness_of_ventilator_weaning patient
        check_for_vac patient
        check_for_pneumonia patient
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
        (observations.any? { |obs| Helper.int_eql_value(obs, PLATEAU_PRESSURE_THRESHOLD) })
      end
    end

    def pressure_support_check
      Proc.new do |observations|
        (observations.any? { |obs| !obs.value.blank? and (obs.value.downcase == "ps" or obs.value.downcase == "pressure support") })
      end
    end

    def fraction_o2_check
      Proc.new do |observations|
        #(observations.select { |obs| Helper.consecutive_float_above_value_in_time_window(obs, INSPIRED_O2_THRESHOLD, 2 * 60) }.size > 1)
        (observations.any? { |obs| Helper.float_below_value_in_time_window(obs, INSPIRED_O2_THRESHOLD, 2 * 60) })
      end
    end

    # Been on a ventilator for 3 or more days
    def ventilator_days_check
      Proc.new do |observations|
        Helper.consecutive_days_with_observation(observations.select { |obs| obs.value.downcase == "y" or obs.value.downcase == "yes" }, 3)
      end
    end

    # Partial pressure of oxygen divided by fraction of inspired oxygen < 300. (often abbreviated as PaO2/FiO2)
    def partial_pressure_threshold_check
      Proc.new do |observations|
        paO2 = observations[0]
        fiO2 = observations[1]
        unless paO2.blank? or fiO2.blank?
          if (paO2.last.value.blank? or fiO2.last.value.blank?)
            false
          else
            paO2_value = paO2.last.value.to_f
            fiO2_value = fiO2.last.value.to_f
            ((paO2_value / fiO2_value) < PARTIAL_PRESSURE_THRESHOLD)
          end
        else
          false
        end
      end
    end

    def calculate_tidal_volume patient
      height_obs = Helper.find_most_recent_item(patient, ["LP64598-3", "height", "ht", "50373000"])
      return TIDAL_VOLUME_DEFAULT_MESSAGE if height_obs.blank?

      # Calculate ideal weight based on Devine formula (50.0 + 2.3 kg per inch over 5 feet)
      height_value = height_obs.last
      if (!height_value.units.blank? and height_value.units == "in")
        height_inches = height_value.value.to_f
      else
        height_inches = height_value.value.to_f * 0.393701
      end
      devine_weight = 50.0 + (2.3 * (height_inches - 60))
      tidal_volume = 6 * devine_weight
      if devine_weight < 0 or tidal_volume < 0 then
        return TIDAL_VOLUME_DEFAULT_MESSAGE
      else
        return "Set tidal volume to #{tidal_volume.round(1)} mL (based on ideal wt of #{devine_weight.round(1)} kg)"
      end
    end

    def bronchial_cfu_check
      Proc.new do |observations|
        (observations.any? { |obs| Helper.int_above_value(obs, BRONCHIAL_LAVAGE_CFU_THRESHOLD) })
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

    def check_for_acute_respiratory_distress patient
      guideline = Guideline.find_by_code("RESPIRATORY_ARDS")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false]
      is_met = [false, false, false]
      relevant_observations = [nil, nil, nil]

      # Check if partial pressure below threshold
      has_data[0], is_met[0], relevant_observations[0] = GuidelineManager::process_guideline_step(patient, ["oxygen_ratio_below_300"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1], relevant_observations[1] = GuidelineManager::process_guideline_step(patient, [["paO2", "3148-4"], ["fiO2", "19994-3", "250774007"]],
        pg, 0, Helper.latest_code_exists_proc, partial_pressure_threshold_check) unless is_met[0]

      observations = Hash.new
      observations["Is oxygen ratio below 300?"] = relevant_observations[0]
      unless relevant_observations[1].nil?
        observations["paO2"] = relevant_observations[1][0]
        observations["fiO2"] = relevant_observations[1][1]
      end
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]), observations)

      # Exists confirmation chest x-ray
      has_data[2], is_met[2], relevant_observations[2] = GuidelineManager::process_guideline_step(patient, ["ards_confirmed_chest_radiograph"], pg, 1, Helper.latest_code_exists_proc, Helper.observation_yes_check)

      observations = Hash.new
      observations["Chest x-ray confirms diagnosis?"] = relevant_observations[2]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), is_met[2], !has_data[2], observations)

      if ((is_met[0] or is_met[1]) and (!is_met[2] and !has_data[2]))
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_RESPIRATORY_DISTRESS_ALERT, 3, "Possible Acute Respiratory Distress Syndrome", "", "Possible Acute Respiratory Distress Syndrome", "SNOMEDCT")
      elsif ((is_met[0] or is_met[1]) and is_met[2])
        GuidelineManager::create_action_with_details(pg, guideline.guideline_actions.first, calculate_tidal_volume(patient))
        return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, ACUTE_RESPIRATORY_DISTRESS_ALERT, 5, "Acute Respiratory Distress Syndrome", "67782005", "Acute Respiratory Distress Syndrome", "SNOMEDCT")
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
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["19834-1", "20124-4"], pg, 0, Helper.latest_code_exists_proc, pressure_support_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      # Check plateau pressure
      has_data[2], is_met[2] = GuidelineManager::process_guideline_step(patient, ["rovw_h2o"], pg, 1, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[3], is_met[3] = GuidelineManager::process_guideline_step(patient, ["plateau_pressure", "LP94729-8", "20075-8"], pg, 1, Helper.latest_code_exists_proc, plateau_pressure_check) unless is_met[2]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 1), (is_met[2] or is_met[3]), !(has_data[2] or has_data[3]))

      # Fraction of inspired oxygen
      has_data[4], is_met[4] = GuidelineManager::process_guideline_step(patient, ["rovw_fraction_o2"], pg, 2, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[5], is_met[5] = GuidelineManager::process_guideline_step(patient, ["19994-3", "250774007"], pg, 2, Helper.latest_code_exists_proc, fraction_o2_check) unless is_met[4]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 2), (is_met[4] or is_met[5]), !(has_data[4] or has_data[5]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, READINESS_OF_VENTILATOR_WEANING_ALERT, 5, "Readiness of Ventilator Weaning", nil, nil, nil) if (is_met[0] or is_met[1]) and (is_met[2] or is_met[3]) and (is_met[4] or is_met[5])
    end

    def check_for_vac patient
      guideline = Guideline.find_by_code("RESPIRATORY_VAC_CDC")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false, false, false, false]
      is_met = [false, false, false, false, false]

      #has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["vac_ventilator_days"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      #has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["vent_support", "371786002"], pg, 0, Helper.any_code_exists_proc, ventilator_days_check) unless is_met[0]
      #GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

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
    
    def check_for_pneumonia patient
      guideline = Guideline.find_by_code("RESPIRATORY_PNEUMONIA")
      return unless GuidelineManager::establish_patient_on_guideline patient, guideline
      pg = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
      has_data = [false, false]
      is_met = [false, false]

      has_data[0], is_met[0] = GuidelineManager::process_guideline_step(patient, ["high_bronch_lavage_cfus"], pg, 0, Helper.latest_code_exists_proc, Helper.observation_yes_check)
      has_data[1], is_met[1] = GuidelineManager::process_guideline_step(patient, ["43441-5"], pg, 0, Helper.any_code_exists_proc, bronchial_cfu_check) unless is_met[0]
      GuidelineManager::update_step(Processor::Helper.find_guideline_step(pg, 0), (is_met[0] or is_met[1]), !(has_data[0] or has_data[1]))

      return GuidelineManager::create_alert(patient, guideline, BODY_SYSTEM, PNEUMONIA_ALERT, 5, "Bacterial Pneumonia", "53084003", "Bacterial Pneumonia", "SNOMEDCT") if (is_met[0] or is_met[1])
    end
  end
end