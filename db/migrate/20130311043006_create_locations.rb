class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.integer :type
      t.integer :parent_id
      t.boolean :can_have_patients

      t.timestamps
    end
  end
end
