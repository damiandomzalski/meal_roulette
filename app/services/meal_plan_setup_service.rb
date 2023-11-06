class MealPlanSetupService
  def initialize(user, recipe_params, meal_date = Date.tomorrow)
    @user = user
    @recipe_params = recipe_params
    @meal_date = meal_date
  end

  def call
    ActiveRecord::Base.transaction do
      create_or_update_recipe
      create_recipe_ingredients
      create_meal_plan.persisted?
    end
  end

  private

  def create_or_update_recipe
    @recipe = Recipe.find_or_initialize_by(external_id: @recipe_params[:external_id])
    @recipe.assign_attributes(recipe_attributes)
    @recipe.save!
  end

  def recipe_attributes
    @recipe_params.slice(:name, :instruction, :category, :area, :image_url)
  end

  def create_recipe_ingredients
    @recipe_params[:ingredients_attributes].each do |_index, ingredient_attributes|
      ingredient = Ingredient.find_or_create_by!(name: ingredient_attributes[:name])
      @recipe.recipe_ingredients.create!(ingredient:, quantity: ingredient_attributes[:quantity])
    end
  end

  def create_meal_plan
    @user.meal_plans.create!(recipe: @recipe, date: @meal_date, meal_type: @recipe_params[:meal_type])
  end
end
