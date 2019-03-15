class CreateGuidelineActions < ActiveRecord::Migration
  def change
    create_table :guideline_actions do |t|
      t.integer :guideline_id
      t.string :text

      t.timestamps
    end
  end
end
