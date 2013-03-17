class CreatePatientGuidelineSteps < ActiveRecord::Migration
  def change
    create_table :patient_guideline_steps do |t|
      t.integer :patient_guideline_id
      t.integer :guideline_step_id
      t.boolean :is_met
      t.boolean :requires_data
      t.integer :status

      t.timestamps
    end
  end
end
