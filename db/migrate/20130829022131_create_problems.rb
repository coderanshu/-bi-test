class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.references :observation
      t.string    :status

      t.timestamps
    end
    add_index :problems, :observation_id
  end
end
