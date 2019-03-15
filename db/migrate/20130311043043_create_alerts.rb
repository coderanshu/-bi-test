class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :patient_id
      t.integer :body_system_id
      t.integer :type

      t.timestamps
    end
  end
end
