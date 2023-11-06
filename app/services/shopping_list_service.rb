class ShoppingListService
  def initialize(meal_plans)
    @meal_plans = meal_plans
  end

  def call
    recipe_ids = @meal_plans.map(&:recipe_id)
    recipe_ingredients = RecipeIngredient.includes(:ingredient).where(recipe_id: recipe_ids)

    shopping_list = {}

    recipe_ingredients.find_each do |ri|
      shopping_list[ri.ingredient.name] ||= []
      shopping_list[ri.ingredient.name] << ri.quantity
    end

    shopping_list.transform_values { |quantities| quantities.join(', ') }
  end
end
