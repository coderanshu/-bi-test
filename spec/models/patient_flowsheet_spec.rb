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

require 'spec_helper'

describe PatientFlowsheet do
  pending "add some examples to (or delete) #{__FILE__}"
end
