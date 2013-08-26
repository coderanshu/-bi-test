# == Schema Information
#
# Table name: alert_guideline_steps
#
#  id                        :integer          not null, primary key
#  alert_id                  :integer
#  patient_guideline_step_id :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

require 'spec_helper'

describe AlertGuidelineStep do
  pending "add some examples to (or delete) #{__FILE__}"
end
