# == Schema Information
#
# Table name: guideline_step_observations
#
#  id                        :integer          not null, primary key
#  patient_guideline_step_id :integer
#  observation_id            :integer
#  order                     :integer
#  group                     :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class GuidelineStepObservation < ActiveRecord::Base
  attr_accessible :observation_id, :order, :patient_guideline_step_id, :group

  belongs_to :patient_guideline_step
  belongs_to :observation

  # Observations should be in the form:
  #   ["group1" => [obs1, obs2], "group2" => [obs3]]
  def self.process_list(patient_guideline_step_id, grouped_observations)
    # Start by wiping out everything related to this patient guideline step
    existing_entries = GuidelineStepObservation.find_all_by_patient_guideline_step_id(patient_guideline_step_id)
    existing_entries.each { |e| e.delete } unless existing_entries.nil?

    return if grouped_observations.nil? or grouped_observations.empty?

    # Now loop through and create the entries
    grouped_observations.each do |group, observations|
      group_counter = 1
      unless observations.nil? or observations.empty?
        observations.each do |obs|
          GuidelineStepObservation.create(:patient_guideline_step_id => patient_guideline_step_id, :observation_id => obs.id,
            :order => group_counter, :group => group)
          group_counter = group_counter + 1
        end
      end
    end
  end
end
