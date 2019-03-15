class CreateAlertGuidelineSteps < ActiveRecord::Migration
  def change
    create_table :alert_guideline_steps do |t|
      t.integer :alert_id
      t.integer :patient_guideline_step_id

      t.timestamps
    end
  end
end
