module GuidelineStepObservationsHelper
  def format_observation_value_for_display obs
    if !obs.question_id.nil? and obs.question.question_type == "choice" and obs.question.constraints == "YesNo"
      if obs.value == "Y"
        return "Yes"
      elsif obs.value == "N"
        return "No"
      else
        return "(Unknown)"
      end
    end

    obs.value
  end

  def group_guideline_step_observations observations
    grouped_obs = {}
    observations.each do |obs|
      grouped_obs[obs.group] = [] if grouped_obs[obs.group].nil?
      grouped_obs[obs.group].push(obs)
    end
    grouped_obs
  end
end
