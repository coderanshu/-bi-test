class CreatePatientLocations < ActiveRecord::Migration
  def change
    create_table :patient_locations do |t|
      t.integer :patient_id
      t.integer :location_id
      t.integer :status

      t.timestamps
    end
  end
end
