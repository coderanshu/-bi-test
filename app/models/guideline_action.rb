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

class GuidelineAction < ActiveRecord::Base
  belongs_to :guideline
  has_many :patient_guideline_actions
  attr_accessible :guideline_id, :text
end
