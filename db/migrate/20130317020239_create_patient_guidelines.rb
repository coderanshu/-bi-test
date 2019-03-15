class CreatePatientGuidelines < ActiveRecord::Migration
  def change
    create_table :patient_guidelines do |t|
      t.integer :guideline_id
      t.integer :patient_id
      t.integer :status

      t.timestamps
    end
  end
end
