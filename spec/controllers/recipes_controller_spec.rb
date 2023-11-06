require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  let(:user) { create(:user) }
  let!(:meal_plans) { create_list(:meal_plan, 4, user:) }
  let(:recipes) { meal_plans.map(&:recipe) }
  let(:recipe) { recipes.first }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns @recipes from the user's meal plans" do
      get :index
      expect(assigns(:recipes)).to match_array(recipes)
    end

    it "filters recipes by name" do
      get :index, params: { q: { name_cont: recipe.name } }
      expect(assigns(:recipes)).to eq([recipe])
    end
  end

  describe "GET #random" do
    context "when there are missing meal types" do
      before do
        allow(MealPlan).to receive(:missing_meal_types).and_return(['breakfast'])
      end

      it "assigns a random recipe" do
        allow_any_instance_of(MealApiService).to receive(:random_recipe).and_return(recipe)
        get :random
        expect(assigns(:recipe)).to eq(recipe)
      end

      it "renders the preview template" do
        allow_any_instance_of(MealApiService).to receive(:random_recipe).and_return(recipe)
        get :random
        expect(response).to render_template('preview')
      end
    end

    context "when there are no missing meal types" do
      it "redirects to the root path with an alert" do
        allow(MealPlan).to receive(:missing_meal_types).and_return([])
        get :random
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('recipes.random.no_missing_meal_types'))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested recipe" do
      expect do
        delete :destroy, params: { id: recipe.id }
      end.to change(Recipe, :count).by(-1)
    end

    it "redirects to the recipes list" do
      delete :destroy, params: { id: recipe.id }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #add_to_meal_plan" do
    let(:recipe_attributes) { attributes_for(:recipe) }

    context "when the recipe is successfully created" do
      it "redirects to the root path with a notice" do
        allow_any_instance_of(MealPlanSetupService).to receive(:call).and_return(true)
        post :add_to_meal_plan, params: { recipe: recipe_attributes }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t('recipes.add_to_meal_plan.success'))
      end
    end

    context "when the recipe creation fails" do
      it "redirects to the root path with an alert" do
        allow_any_instance_of(MealPlanSetupService).to receive(:call).and_return(false)
        post :add_to_meal_plan, params: { recipe: recipe_attributes }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t('recipes.add_to_meal_plan.failure'))
      end
    end

    context "when an ActiveRecord::RecordInvalid error is raised" do
      it "redirects to the root path with an error message" do
        allow_any_instance_of(MealPlanSetupService).to receive(:call).and_raise(ActiveRecord::RecordInvalid.new(Recipe.new))
        post :add_to_meal_plan, params: { recipe: recipe_attributes }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to include(I18n.t('recipes.add_to_meal_plan.error'))
      end
    end
  end

  describe "GET #reject" do
    it "redirects to the random recipe path" do
      get :reject
      expect(response).to redirect_to(random_recipes_path)
    end
  end

  describe "authentication" do
    before do
      sign_out user
    end

    it "redirects unauthenticated users to the sign-in page" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
