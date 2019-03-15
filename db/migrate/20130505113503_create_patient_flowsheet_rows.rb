class CreatePatientFlowsheetRows < ActiveRecord::Migration
  def change
    create_table :patient_flowsheet_rows do |t|
      t.integer :patient_flowsheet_id

      t.timestamps
    end
  end
end
