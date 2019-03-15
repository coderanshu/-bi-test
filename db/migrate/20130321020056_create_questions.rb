class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :guideline_step_id
      t.string :code
      t.string :display
      t.string :question_type
      t.string :constraints
      t.integer :order

      t.timestamps
    end
  end
end
