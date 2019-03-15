class AddPatientFlowsheetRowIdToObservations < ActiveRecord::Migration
  def change
    add_column :observations, :patient_flowsheet_row_id, :integer
  end
end
