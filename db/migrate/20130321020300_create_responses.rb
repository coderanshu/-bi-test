class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :question_id
      t.integer :patient_id
      t.string :value

      t.timestamps
    end
  end
end
