class Guideline < ActiveRecord::Base
  has_many :guideline_steps
  belongs_to :body_system
  attr_accessible :description, :name, :organization, :url, :body_system_id
end
