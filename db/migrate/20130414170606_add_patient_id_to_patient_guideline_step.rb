class AddPatientIdToPatientGuidelineStep < ActiveRecord::Migration
  def change
    add_column :patient_guideline_steps, :patient_id, :integer
  end
end
