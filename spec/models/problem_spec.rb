# == Schema Information
#
# Table name: problems
#
#  id             :integer          not null, primary key
#  observation_id :integer
#  status         :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  alert_id       :integer
#

require 'spec_helper'

describe Problem do
  pending "add some examples to (or delete) #{__FILE__}"
end
