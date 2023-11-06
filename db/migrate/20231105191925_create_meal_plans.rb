class CreateMealPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.string :meal_type, null: false
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
    add_index :meal_plans, [:user_id, :date, :meal_type], unique: true
  end
end
