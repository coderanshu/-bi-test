# == Schema Information
#
# Table name: locations
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  location_type     :integer
#  parent_id         :integer
#  can_have_patients :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Location < ActiveRecord::Base
  has_many :patient_locations
  attr_accessible :can_have_patients, :name, :parent_id, :location_type

  scope :for_patients, where(:can_have_patients => true)

  def assigned_patient
    active_recs = patient_locations.active
    active_recs.first.patient unless active_recs.blank?
  end

  def updates_since? last_update
    if self.can_have_patients
      # Any changes to the patient locations associated with this location?
      #if self.patient_locations.active.updated_since(last_update).blank?
        # Any changes to the patient record?
        patient_loc = self.patient_locations.active.first
        return false if patient_loc.blank?
        return patient_loc.patient.updates_since?(last_update)
      #end
      #return true
    end
    false
  end
end
