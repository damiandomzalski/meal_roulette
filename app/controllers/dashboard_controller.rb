class DashboardController < ApplicationController
  def index
    @upcoming_meal_plans = current_user.meal_plans.upcoming
    @missing_meal_types = MealPlan.missing_meal_types(current_user, Date.tomorrow)
    @shopping_list = generate_shopping_list
  end

  private

  def generate_shopping_list
    recipe_ids = @upcoming_meal_plans.map(&:recipe_id)
    recipe_ingredients = RecipeIngredient.includes(:ingredient).where(recipe_id: recipe_ids)

    shopping_list = {}

    recipe_ingredients.find_each do |ri|
      shopping_list[ri.ingredient.name] ||= []
      shopping_list[ri.ingredient.name] << ri.quantity
    end

    shopping_list.transform_values { |quantities| quantities.join(', ') }
  end
end
