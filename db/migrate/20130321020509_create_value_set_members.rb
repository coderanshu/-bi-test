class CreateValueSetMembers < ActiveRecord::Migration
  def change
    create_table :value_set_members do |t|
      t.integer :value_set_id
      t.string  :code
      t.string  :name
      t.string  :description

      t.timestamps
    end
  end
end
