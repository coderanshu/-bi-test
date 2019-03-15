module AlertsHelper
  def alert_css_class alert
    return "critical" if alert.severity >= 4
    return "warning" if alert.severity == 3
    ""
  end

  def alert_action alert, action
  	existing_action = PatientGuidelineAction.find_by_patient_id_and_guideline_action_id(alert.patient_id, action.id)
  	if existing_action.blank? or existing_action.action.blank?
	    button_tag "Mark completed", { :class => "action-button", :data => {:action => "Completed", :actionid => action.id } }
    else
      raw " <i>(#{existing_action.action} on #{format_date_time(existing_action.acted_on)})</i>"
    end
  end
end
