# == Schema Information
#
# Table name: guideline_actions
#
#  id           :integer          not null, primary key
#  guideline_id :integer
#  text         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe GuidelineAction do
  pending "add some examples to (or delete) #{__FILE__}"
end
