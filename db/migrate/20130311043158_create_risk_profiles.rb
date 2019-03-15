class CreateRiskProfiles < ActiveRecord::Migration
  def change
    create_table :risk_profiles do |t|
      t.integer :patient_id
      t.string :description

      t.timestamps
    end
  end
end
