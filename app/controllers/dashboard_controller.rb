class DashboardController < ApplicationController
  def index
    @upcoming_meal_plans = current_user.meal_plans.upcoming
    @missing_meal_types = MealPlan.missing_meal_types(current_user, Date.tomorrow)
    @shopping_list = ShoppingListService.new(@upcoming_meal_plans).call
  end
end
