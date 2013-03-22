class AddQuestionIdToObservation < ActiveRecord::Migration
  def change
    add_column :observations, :question_id, :integer
  end
end
