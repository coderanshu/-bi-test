class CreatePatientGuidelineActions < ActiveRecord::Migration
  def change
    create_table :patient_guideline_actions do |t|
      t.integer :patient_id
      t.integer :guideline_action_id
      t.integer :patient_guideline_id
      t.integer :acted_id
      t.datetime :acted_on
      t.string :action
      t.integer :status

      t.timestamps
    end
  end
end
