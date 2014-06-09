module Processor
  class Helper
    def self.find_most_recent_item(patient, codes)
      find_most_recent_items(patient, codes, 1)
    end

    def self.find_most_recent_items(patient, codes, num_items)
      return nil if codes.blank?
      if codes[0].kind_of?(Array)
        observations = Array.new
        codes.each { |code_set| observations.push(find_most_recent_items(patient, code_set, num_items)) }
        observations
      else
        # Sort by newest date, but in the case of a tie-breaker, the last one entered is considered newest
        patient.observations.where(:code => codes).order('observed_on DESC, id DESC').limit(num_items)
      end
    end

    def self.find_oldest_item(patient, codes)
      find_oldest_items(patient, codes, 1)
    end

    def self.find_oldest_items(patient, codes, num_items)
      return nil if codes.blank?
      if codes[0].kind_of?(Array)
        observations = Array.new
        codes.each { |code_set| observations.push(find_oldest_items(patient, code_set, num_items)) }
        observations
      else
        # Sort by oldest date, but in the case of a tie-breaker, the first one entered is considered oldest
        patient.observations.where(:code => codes).order('observed_on, id').limit(num_items)
      end
    end

    def self.find_all_items(patient, codes)
      return nil if codes.blank? or patient.nil?
      if codes[0].kind_of?(Array)
        observations = Array.new
        codes.each { |code_set| observations.push(find_all_items(patient, code_set)) }
        observations
      else
        patient.observations.where(:code => codes).order('observed_on DESC, id DESC')
      end
    end

    def self.find_guideline_step(patient_guideline, guideline_index)
      return nil if patient_guideline.guideline.guideline_steps[guideline_index].nil?
      PatientGuidelineStep.find_by_guideline_step_id_and_patient_guideline_id(patient_guideline.guideline.guideline_steps[guideline_index].id, patient_guideline.id)
    end

    # Verifies that the latest of a code set meets some criteria
    def self.latest_code_exists_proc
      Proc.new do |patient, codes, validation_check|
        has_data = false
        is_met = false
        observations = find_most_recent_item(patient, codes)
        unless observations.blank?
          if observations.kind_of?(Array)
            has_data = observations.all?{|x| !x.blank?}
          else
            has_data = true
          end
          is_met = validation_check.call(observations) if has_data
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
          if observations.kind_of?(Array)
            has_data = observations.all?{|x| !x.blank?}
          else
            has_data = true
          end
          is_met = validation_check.call(observations) if has_data
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
      regex_match = (name.to_s =~ /^(consecutive_)?(int|float)_(difference_)?(above|below|eql|lt_eql|gt_eql)_value(_in_time_window)?$/)
      super unless regex_match
      if $3
        return Helper.send("num_difference_#{$4}_value#{$5}", args[0], args[1], $2[0])
      else
        if $5
          return Helper.send("#{$1}num_#{$4}_value#{$5}", args[0], args[1], args[2], $2[0])
        else
          return Helper.send("#{$1}num_#{$4}_value#{$5}", args[0], args[1], $2[0])
        end
      end
      super
    end

    def self.num_above_value(observation, value, num_type)
      (observation.value.send("to_#{num_type}") > value)
    end

    def self.num_below_value(observation, value, num_type)
      (observation.value.send("to_#{num_type}") < value)
    end

    def self.num_eql_value(observation, value, num_type)
      (observation.value.send("to_#{num_type}") == value)
    end

    def self.num_lt_eql_value(observation, value, num_type)
      (observation.value.send("to_#{num_type}") <= value)
    end

    def self.num_gt_eql_value(observation, value, num_type)
      (observation.value.send("to_#{num_type}") >= value)
    end

    def self.num_below_value_in_time_window(observation, value, time_window_minutes, num_type)
      (observation.value.send("to_#{num_type}") < value)
    end

    def self.num_difference_below_value(observations, value, num_type)
      return false if observations.blank? or observations.length < 2
      (observations.last.value.send("to_#{num_type}") - observations.first.value.send("to_#{num_type}")) < value
    end

    def self.num_difference_above_value(observations, value, num_type)
      return false if observations.blank? or observations.length < 2
      (observations.last.value.send("to_#{num_type}") - observations.first.value.send("to_#{num_type}")) > value
    end

    def self.consecutive_days_with_observation(observations, num_days)
      day_count = 0
      last_day = nil
      observations.order('observed_on DESC, id DESC').each do |obs|
        if (last_day.nil?)
          unless obs.observed_on.blank?
            day_count = day_count + 1
            last_day = obs.observed_on.to_date
          end
        else
          days_diff = (last_day - obs.observed_on.to_date)
          if (days_diff == 1)
            day_count = day_count + 1
          elsif (days_diff != 0)
            day_count = 1
          end
          last_day = obs.observed_on.to_date
        end
      end
      day_count >= num_days
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