# == Schema Information
#
# Table name: patient_guidelines
#
#  id           :integer          not null, primary key
#  guideline_id :integer
#  patient_id   :integer
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe PatientGuideline do
  pending "add some examples to (or delete) #{__FILE__}"
end
