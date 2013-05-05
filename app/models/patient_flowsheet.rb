class PatientFlowsheet < ActiveRecord::Base
  has_many :patient_flowsheet_rows

  attr_accessible :flowsheet_id, :patient_id, :template
end
