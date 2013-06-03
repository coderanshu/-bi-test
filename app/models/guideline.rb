class Guideline < ActiveRecord::Base
  has_many :guideline_steps
  has_many :guideline_actions
  has_many :alerts
  belongs_to :body_system
  attr_accessible :description, :name, :organization, :url, :body_system_id, :code

  scope :updated_since, lambda { |last_update| where("guidelines.updated_at >= ? OR guidelines.created_at >= ?", last_update, last_update) }
end
