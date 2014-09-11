class CreateGuidelineStepObservations < ActiveRecord::Migration
  def change
    create_table :guideline_step_observations do |t|
      t.integer :patient_guideline_step_id
      t.integer :observation_id
      t.integer :order
      t.string  :group

      t.timestamps
    end
  end
end
