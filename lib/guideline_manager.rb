require "./lib/processors/helper"

module GuidelineManager
  def self.establish_patient_on_guideline patient, guideline
    if patient.blank? or guideline.blank?
      puts "The patient and/or guideline could not be found"
      return false
    end

    existing_guideline = PatientGuideline.find_by_patient_id_and_guideline_id(patient.id, guideline.id)
    if existing_guideline.blank?
      puts "The patient is not already on the #{guideline.code} guideline, and will be added"
      pg = PatientGuideline.create(:patient_id => patient.id, :guideline_id => guideline.id, :status => 1)
      guideline.guideline_steps.each do |step|
        PatientGuidelineStep.create(:guideline_step_id => step.id, :patient_guideline_id => pg.id, :is_met => false, :requires_data => true, :status => 1, :patient_id => patient.id)
      end
    else
      #puts "The patient is already on the #{guideline.code} guideline"
      # Make sure the patient is on all of the steps
      guideline.guideline_steps.each_with_index do |step, index|
        existing_step = Processor::Helper.find_guideline_step(existing_guideline, index)
        if existing_step.blank?
          PatientGuidelineStep.create(:guideline_step_id => step.id, :patient_guideline_id => existing_guideline.id, :is_met => false, :requires_data => true, :status => 1, :patient_id => patient.id)
          puts "Add patient to guideline step #{index + 1}"
        end
      end
    end
    true
  end

  def self.process_guideline_step(patient, codes, patient_guideline, step_index, validation_proc, validation_check)
    step = Processor::Helper.find_guideline_step(patient_guideline, step_index)
    return nil if step.nil?
    has_data, is_met, relevant_observations = validation_proc.call(patient, codes, validation_check)
    #update_step(step, is_met, !has_data)
    [has_data, is_met, relevant_observations]
  end

  def self.update_step(step, is_met, requires_data, observations = nil)
    is_met_value = is_met.nil? ? step.is_met : is_met
    requires_data_value = requires_data.nil? ? step.requires_data : requires_data

    GuidelineStepObservation.process_list(step.id, observations)

    # Only update the step if the values are different
    if (step.is_met != is_met_value or step.requires_data != requires_data_value)
      step.update_attributes(:is_met => is_met_value, :requires_data => requires_data_value)
    end
  end

  def self.create_alert(patient, guideline, body_system, alert_type, severity, description, problem_code, problem_description, problem_code_system)
    problem_code_system ||= "SNOMEDCT"
    severity ||= 3
    existing_alerts = Alert.find_all_by_body_system_id_and_patient_id_and_alert_type(body_system, patient.id, alert_type)
    if existing_alerts.blank?
      puts "The alert doesn't exist, and will be created"
      alert = Alert.create(:body_system_id => body_system, :patient_id => patient.id, :alert_type => alert_type, :severity => severity, :description => description, :status => 1)
      alert.update_attributes(:guideline_id => guideline.id) unless guideline.blank?
      unless problem_description.blank? or problem_code.blank?
        obs = Observation.create(:patient_id => patient.id, :name => problem_description, :code_system => problem_code_system, :code => problem_code)
        Problem.create(:observation_id => obs.id, :status => 'Possible', :alert_id => alert.id)
      end
      alert
    elsif existing_alerts.last.severity < severity
      puts "Alert exists - updating the alert to be a more severe instance"
      existing_alerts.last.update_attributes(:severity => severity, :description => description)
      nil
    else
      #puts "This alert already exists"
      nil
    end
  end

  def self.create_action_with_details(patient_guideline, guideline_action, details)
    existing_action = PatientGuidelineAction.find_by_patient_id_and_guideline_action_id(patient_guideline.patient_id, guideline_action.id)
    if existing_action.blank?
      PatientGuidelineAction.create(:patient_id => patient_guideline.patient_id, :guideline_action_id => guideline_action.id, :patient_guideline_id => patient_guideline.id)
    elsif existing_action.action.blank?
      existing_action.update_attributes(:details => details)
    end
  end
end