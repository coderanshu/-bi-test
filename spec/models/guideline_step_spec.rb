# == Schema Information
#
# Table name: guideline_steps
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  description  :string(255)
#  order        :integer
#  guideline_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe GuidelineStep do
  pending "add some examples to (or delete) #{__FILE__}"
end
