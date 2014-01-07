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
      puts "The patient is already on the #{guideline.code} guideline"
    end
    true
  end
  
  def self.process_guideline_step(patient, codes, patient_guideline, step_index, validation_proc, validation_check)
    step = Processor::Helper.find_guideline_step(patient_guideline, step_index)
    return nil if step.nil?
    has_data, is_met = validation_proc.call(patient, codes, validation_check)
    step.update_attributes(:is_met => is_met, :requires_data => !has_data)
    [has_data, is_met]
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
    else
      puts "This alert already exists"
      nil
    end
  end
end