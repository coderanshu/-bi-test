class Guideline < ActiveRecord::Base
  has_many :guideline_steps
  belongs_to :body_system
  attr_accessible :description, :name, :organization, :url, :body_system_id

  scope :updated_since, lambda { |last_update| where("guidelines.updated_at >= ? OR guidelines.created_at >= ?", last_update, last_update) }
end
