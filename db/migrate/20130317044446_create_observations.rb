class CreateObservations < ActiveRecord::Migration
  def change
    create_table :observations do |t|
      t.string :name
      t.string :value_text
      t.integer :value_numeric
      t.datetime :value_timestamp
      t.integer :patient_id

      t.timestamps
    end
  end
end
