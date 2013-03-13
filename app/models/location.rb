class Location < ActiveRecord::Base
  has_many :patient_locations
  attr_accessible :can_have_patients, :name, :parent_id, :location_type

  def assigned_patient
    patient_locations.first.patient unless patient_locations.blank?  
  end
end
