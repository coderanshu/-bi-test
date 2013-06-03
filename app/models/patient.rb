class Patient < ActiveRecord::Base
  has_many :patient_locations
  has_many :patient_guidelines
  has_many :guidelines, :through => :patient_guidelines
  has_many :patient_guideline_steps, :through => :patient_guidelines
  has_many :patient_guideline_actions, :through => :patient_guidelines
  has_many :alerts
  has_many :observations
  has_many :patient_checklists
  attr_accessible :first_name, :last_name, :middle_name, :prefix, :source_mrn, :suffix

  scope :updated_since, lambda { |last_update| where("patient.updated_at >= ? OR patient.created_at >= ?", last_update, last_update) }

  def name
    first_name << " " << last_name  
  end

  def updates_since? last_update
    return true unless self.patient_guidelines.updated_since(last_update).blank?
    return true unless self.patient_guideline_steps.updated_since(last_update).blank?
    return true unless self.patient_guideline_actions.updated_since(last_update).blank?
    return true unless self.guidelines.updated_since(last_update).blank?
    return true unless self.alerts.updated_since(last_update).blank?
    return true unless self.observations.updated_since(last_update).blank?
    false
  end
end
