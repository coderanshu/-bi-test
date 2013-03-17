class GuidelineStep < ActiveRecord::Base
  belongs_to :guideline
  attr_accessible :description, :guideline_id, :name, :order

  scope :ordered, order("guideline_steps.[order]")
end
