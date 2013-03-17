class CreateGuidelines < ActiveRecord::Migration
  def change
    create_table :guidelines do |t|
      t.string :name
      t.string :organization
      t.string :url
      t.string :description

      t.timestamps
    end
  end
end
