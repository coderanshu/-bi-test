class PatientFlowsheetRow < ActiveRecord::Base
  belongs_to :patient_flowsheet
  has_many :observations
  attr_accessible :patient_flowsheet_id
end
