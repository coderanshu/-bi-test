module LocationsHelper
  def location_header location
    return "(Unknown)" if location.nil?
    if location.can_have_patients and !location.patient_locations.blank?
      return "<span class='name'>#{location.assigned_patient.name}</span><span class='demographics'></span>"
    end
    location.name
  end

  def patient_location_score location
    return 0 if location.assigned_patient.blank?
    patient = location.assigned_patient
    total = 0
    patient.alerts.each { |alert| total = total + alert.severity }
    total
  end
end
