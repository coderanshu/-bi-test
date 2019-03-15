# == Schema Information
#
# Table name: patient_guideline_steps
#
#  id                   :integer          not null, primary key
#  patient_guideline_id :integer
#  guideline_step_id    :integer
#  is_met               :boolean
#  requires_data        :boolean
#  status               :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  patient_id           :integer
#

require 'spec_helper'

describe PatientGuidelineStep do
  pending "add some examples to (or delete) #{__FILE__}"
end
