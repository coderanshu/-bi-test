module Processor
  class Helper
    def self.find_most_recent_item(patient, codes)
      find_most_recent_items(patient, codes, 1)
    end

    def self.find_most_recent_items(patient, codes, num_items)
      return nil if codes.blank?
      if codes[0].kind_of?(Array)
        observations = Array.new
        codes.each { |code_set| observations.push(find_most_recent_items(patient, codes[0], num_items)) }
        observations
      else
        patient.observations.where(:code => codes).order('observed_on DESC').limit(num_items)
      end
    end

    def self.find_all_items(patient, codes)
      return nil if codes.blank? or patient.nil?
      if codes[0].kind_of?(Array)
        observations = Array.new
        codes.each { |code_set| observations.push(find_all_items(patient, codes[0])) }
        observations
      else
        patient.observations.where(:code => codes)
      end
    end

    def self.find_guideline_step(patient_guideline, guideline_index)
      PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(patient_guideline.guideline.guideline_steps[guideline_index].id, patient_guideline.id)
    end

    # Verifies that the latest of a code set meets some criteria
    def self.latest_code_exists_proc
      Proc.new do |patient, codes, validation_check|
        has_data = false
        is_met = false
        observations = find_most_recent_item(patient, codes)
        unless observations.blank?
          has_data = true
          is_met = validation_check.call(observations)
        end
        [has_data, is_met]
      end
    end

    # Verifies that any value of a code set meets some critera
    def self.any_code_exists_proc
      Proc.new do |patient, codes, validation_check|
        has_data = false
        is_met = false
        observations = find_all_items(patient, codes)
        unless observations.blank?
          has_data = true
          is_met = validation_check.call(observations)
        end
        [has_data, is_met]
      end
    end

    def self.observation_yes_check
      Proc.new do |observations|
        (observations.any? { |obs| (obs.value == "Y") })
      end
    end

    def self.method_missing(name, *args)
      regex_match = (name.to_s =~ /^(consecutive_)?(int|float)_(above|below)_value(_in_time_window)?$/)
      super unless regex_match
      if $4
        return Helper.send("#{$1}num_#{$3}_value#{$4}", args[0], args[1], args[2], $2[0])
      else
        return Helper.send("#{$1}num_#{$3}_value#{$4}", args[0], args[1], $2[0])
      end
      super
    end

    def self.num_above_value(observation, value, num_type)
      (observation.value.send("to_#{num_type}") > value)
    end
    
    def self.num_below_value(observation, value, num_type)
      (observation.value.send("to_#{num_type}") < value)
    end

    def self.consecutive_num_above_value(observations, value, num_type)
      prev_match = false
      observations.each do |obs|
        return true if prev_match && (num_above_value(obs, value, num_type))
        prev_match = (num_above_value(obs, value, num_type))
      end
      false
    end
    
    def self.consecutive_num_below_value_in_time_window(observations, value, time_window_minutes, num_type)
      prev_match = false
      observations.each do |obs|
        return true if prev_match && (num_below_value(obs, value, num_type))
        prev_match = (num_below_value(obs, value, num_type))
      end
      false
    end
    
    def self.consecutive_num_above_value_in_time_window(observations, value, time_window_minutes, num_type)
      prev_match = false
      observations.each do |obs|
        return true if prev_match && (num_above_value(obs, value, num_type))
        prev_match = (num_above_value(obs, value, num_type))
      end
      false
    end
  end
end