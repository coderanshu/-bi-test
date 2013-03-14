module LocationsHelper
  def location_header location
    return "(Unknown)" if location.nil?
    if location.can_have_patients and !location.patient_locations.blank?
      return "<span class='name'>#{location.assigned_patient.name}</span><span class='demographics'></span>"
    end
    location.name
  end
end
