# == Schema Information
#
# Table name: patient_checklists
#
#  id           :integer          not null, primary key
#  checklist_id :integer
#  patient_id   :integer
#  date         :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe PatientChecklist do
  pending "add some examples to (or delete) #{__FILE__}"
end
