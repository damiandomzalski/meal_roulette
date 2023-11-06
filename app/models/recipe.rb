class Recipe < ApplicationRecord
  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :meal_plans, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :instruction, presence: true
end
