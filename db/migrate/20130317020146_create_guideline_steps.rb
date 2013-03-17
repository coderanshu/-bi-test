class CreateGuidelineSteps < ActiveRecord::Migration
  def change
    create_table :guideline_steps do |t|
      t.string :name
      t.string :description
      t.integer :order
      t.integer :guideline_id

      t.timestamps
    end
  end
end
