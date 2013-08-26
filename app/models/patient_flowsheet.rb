# == Schema Information
#
# Table name: patient_flowsheets
#
#  id           :integer          not null, primary key
#  flowsheet_id :integer
#  patient_id   :integer
#  template     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class PatientFlowsheet < ActiveRecord::Base
  has_many :patient_flowsheet_rows

  attr_accessible :flowsheet_id, :patient_id, :template
end
