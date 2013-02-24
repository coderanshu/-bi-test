class CreateBodySystems < ActiveRecord::Migration
  def change
    create_table :body_systems do |t|
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
