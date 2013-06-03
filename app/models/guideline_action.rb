class GuidelineAction < ActiveRecord::Base
  belongs_to :guideline
  has_many :patient_guideline_actions
  attr_accessible :guideline_id, :text
end
