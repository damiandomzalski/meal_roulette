require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET #index" do
    let(:user) { create(:user) }
    let!(:meal_plans) { create_list(:meal_plan, 3, user:, date: Date.tomorrow) }
    let!(:ingredients) { create_list(:ingredient, 3) }

    before do
      ingredients.each do |ingredient|
        create(:recipe_ingredient, recipe: meal_plans.first.recipe, ingredient:, quantity: "1 teaspoon")
      end
      sign_in user
      get :index
    end

    it "assigns @upcoming_meal_plans" do
      expect(assigns(:upcoming_meal_plans)).to match_array(meal_plans)
    end

    it "assigns @missing_meal_types" do
      expect(assigns(:missing_meal_types)).to eq(MealPlan.missing_meal_types(user, Date.tomorrow))
    end

    it "assigns @shopping_list" do
      expected_shopping_list = {
        ingredients.first.name => "1 teaspoon",
        ingredients.second.name => "1 teaspoon",
        ingredients.third.name => "1 teaspoon"
      }
      expect(assigns(:shopping_list)).to eq(expected_shopping_list)
    end

    it "renders the index template" do
      expect(response).to render_template("index")
    end
  end

  describe "authentication" do
    it "redirects unauthenticated users" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
