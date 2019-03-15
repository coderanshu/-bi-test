# == Schema Information
#
# Table name: patient_locations
#
#  id          :integer          not null, primary key
#  patient_id  :integer
#  location_id :integer
#  status      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PatientLocation < ActiveRecord::Base
  belongs_to :location
  belongs_to :patient
  attr_accessible :location_id, :patient_id, :status

  scope :active, where(:status => 1)
  scope :updated_since, lambda { |last_update| where("patient_locations.updated_at >= ? OR patient_locations.created_at >= ?", last_update, last_update) }
end
