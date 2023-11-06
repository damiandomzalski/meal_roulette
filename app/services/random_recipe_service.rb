class RandomRecipeService
  attr_reader :user, :service, :recipe, :ingredients, :missing_meal_types

  def initialize(user)
    @user = user
    @service = MealApiService.new
  end

  def call
    set_missing_meal_types
    return false if missing_meal_types.empty?

    set_recipe
    return false unless recipe

    set_ingredients
    true
  end

  private

  def set_missing_meal_types
    @missing_meal_types = MealPlan.missing_meal_types(user, Date.tomorrow)
  end

  def set_recipe
    @recipe = service.random_recipe
  end

  def set_ingredients
    @ingredients = service.extract_ingredients(recipe) if recipe
  end
end
