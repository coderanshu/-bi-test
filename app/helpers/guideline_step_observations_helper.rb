module GuidelineStepObservationsHelper
  def format_observation_value_for_display obs
    return "" if obs.value.empty?

    if !obs.question_id.nil? and obs.question.question_type = "choice" and obs.question.constraints = "Y/N"
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
end
