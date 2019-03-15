class CreateValueSets < ActiveRecord::Migration
  def change
    create_table :value_sets do |t|
      t.string :code
      t.string :code_system
      t.string :name
      t.string :description
      t.string :source

      t.timestamps
    end
  end
end
