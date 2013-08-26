# == Schema Information
#
# Table name: patient_flowsheet_rows
#
#  id                   :integer          not null, primary key
#  patient_flowsheet_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class PatientFlowsheetRow < ActiveRecord::Base
  belongs_to :patient_flowsheet
  has_many :observations
  attr_accessible :patient_flowsheet_id
end
