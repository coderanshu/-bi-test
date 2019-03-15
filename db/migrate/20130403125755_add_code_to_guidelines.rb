class AddCodeToGuidelines < ActiveRecord::Migration
  def change
    add_column :guidelines, :code, :string
  end
end
