class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :source_mrn
      t.string :prefix
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :suffix

      t.timestamps
    end
  end
end
