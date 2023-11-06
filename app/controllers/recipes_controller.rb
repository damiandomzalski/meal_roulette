class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :destroy]

  def index
    @q = current_user.recipes.ransack(params[:q])
    @recipes = @q.result(distinct: true).order(:name).paginate(page: params[:page])
  end

  def random
    random_recipe_service = RandomRecipeService.new(current_user)

    if random_recipe_service.call
      @recipe = random_recipe_service.recipe
      @ingredients = random_recipe_service.ingredients
      @missing_meal_types = random_recipe_service.missing_meal_types
      render 'preview'
    else
      alert_key = random_recipe_service.missing_meal_types.empty? ? 'no_missing_meal_types' : 'failure'
      redirect_to root_path, alert: I18n.t("recipes.random.#{alert_key}")
    end
  end

  def destroy
    if @recipe.destroy
      redirect_to root_path, notice: I18n.t('recipes.destroy.success')
    else
      redirect_to @recipe, alert: I18n.t('recipes.destroy.failure')
    end
  end

  def add_to_meal_plan
    service = MealPlanSetupService.new(current_user, recipe_params)

    if service.call
      redirect_to root_path, notice: I18n.t('recipes.add_to_meal_plan.success')
    else
      redirect_to root_path, alert: I18n.t('recipes.add_to_meal_plan.failure')
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to root_path, alert: I18n.t('recipes.add_to_meal_plan.error') + e.message
  end

  def reject
    redirect_to random_recipes_path
  end

  private

  def recipe_params
    params.require(:recipe).permit(
      :name, :instruction, :category, :area, :image_url, :external_id, :meal_type,
      ingredients_attributes: [:name, :quantity]
    )
  end

  def set_recipe
    @recipe = Recipe.find_by(id: params[:id])
    redirect_to root_path, alert: I18n.t('recipes.not_found') unless @recipe
  end
end
