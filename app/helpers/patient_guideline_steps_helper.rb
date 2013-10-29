module PatientGuidelineStepsHelper
  def fill_in_step_details patient, text
    return "" if text.blank?
    observations = Observation.find_all_by_patient_id(patient.id)
    observations.each do |obs|
      formatted_obs = obs.value || ""
      formatted_obs << " #{obs.units}" unless obs.units.blank?
      text = text.gsub("[[#{obs.name}]]", formatted_obs) unless formatted_obs.blank?
    end
    text
  end
end
