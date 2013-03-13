class PatientLocation < ActiveRecord::Base
  belongs_to :location
  belongs_to :patient
  attr_accessible :location_id, :patient_id, :status
end
