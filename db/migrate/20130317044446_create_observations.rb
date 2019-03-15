class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :name
      t.string :value
      t.integer :patient_id

      t.timestamps
    end
  end
end
