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

class GuidelineStep < ActiveRecord::Base
  belongs_to :guideline
  has_many :questions
  attr_accessible :description, :guideline_id, :name, :order

  scope :ordered, order("guideline_steps.[order]")
end
