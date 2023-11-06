class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.text :instruction
      t.string :category
      t.string :area
      t.string :image_url

      t.timestamps
    end

    add_index :recipes, :name, unique: true
  end
end