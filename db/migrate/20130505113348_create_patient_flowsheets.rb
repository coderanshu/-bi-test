class CreatePatientFlowsheets < ActiveRecord::Migration
  def change
    create_table :patient_flowsheets do |t|
      t.integer :flowsheet_id
      t.integer :patient_id
      t.string  :template

      t.timestamps
    end
  end
end
