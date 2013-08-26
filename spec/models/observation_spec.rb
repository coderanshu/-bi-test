# == Schema Information
#
# Table name: observations
#
#  id                       :integer          not null, primary key
#  name                     :string(255)
#  value                    :string(255)
#  patient_id               :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  question_id              :integer
#  code_system              :string(255)
#  observed_on              :datetime
#  code                     :string(255)
#  units                    :string(255)
#  patient_flowsheet_row_id :integer
#

require 'spec_helper'

describe Observation do
  pending "add some examples to (or delete) #{__FILE__}"
end
