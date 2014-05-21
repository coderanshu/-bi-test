# == Schema Information
#
# Table name: guidelines
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  organization   :string(255)
#  url            :string(255)
#  description    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  body_system_id :integer
#  code           :string(255)
#  status         :string(255)
#

class Guideline < ActiveRecord::Base
  has_many :guideline_steps
  has_many :guideline_actions
  has_many :alerts
  belongs_to :body_system
  attr_accessible :description, :name, :organization, :url, :body_system_id, :code, :status

  scope :updated_since, lambda { |last_update| where("guidelines.updated_at >= ? OR guidelines.created_at >= ?", last_update, last_update) }
  default_scope where("(guidelines.status IS NULL OR guidelines.status NOT IN (?, ?))", "retired", "deleted")
end
