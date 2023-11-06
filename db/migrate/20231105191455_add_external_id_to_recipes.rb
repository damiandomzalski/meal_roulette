class AddExternalIdToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :external_id, :string
    add_index :recipes, :external_id, unique: true
  end
end
