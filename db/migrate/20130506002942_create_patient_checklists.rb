class CreatePatientChecklists < ActiveRecord::Migration
  def change
    create_table :patient_checklists do |t|
      t.integer  :checklist_id
      t.integer  :patient_id
      t.datetime :date

      t.timestamps
    end
  end
end
