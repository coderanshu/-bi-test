class Location < ActiveRecord::Base
  has_many :patient_locations
  attr_accessible :can_have_patients, :name, :parent_id, :location_type

  def assigned_patient
    patient_locations.first.patient unless patient_locations.blank?  
  end

  def updates_since? last_update
    if self.can_have_patients
      # Any changes to the patient locations associated with this location?
      if self.patient_locations.active.updated_since(last_update).blank?
        # Any changes to the patient record?
        patient_loc = self.patient_locations.active.first
        return false if patient_loc.blank?
        return patient_loc.patient.updates_since?(last_update)
      end
      return true
    end
    false
  end
end
