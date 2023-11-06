require 'rails_helper'

RSpec.describe MealPlanSetupService, type: :service do
  let(:user) { create(:user) }
  let(:recipe_params) do
    {
      external_id: '12345',
      name: 'Test Recipe',
      instruction: 'Some instructions',
      category: 'Dessert',
      area: 'American',
      image_url: 'http://example.com/image.jpg',
      meal_type: 'dinner',
      ingredients_attributes: {
        '0' => { name: 'Sugar', quantity: '100g' },
        '1' => { name: 'Flour', quantity: '200g' }
      }
    }
  end

  describe '#call' do
    context 'when all parameters are valid' do
      it 'successfully creates a recipe, ingredients, and a meal plan' do
        service = MealPlanSetupService.new(user, recipe_params)

        expect { service.call }.to change { Recipe.count }.by(1)
                                                          .and change { Ingredient.count }.by(2)
                                                                                          .and change { user.meal_plans.count }.by(1)
      end
    end

    context 'when the recipe fails to save' do
      it 'raises an ActiveRecord::RecordInvalid error and does not create a meal plan' do
        allow_any_instance_of(Recipe).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(Recipe.new))

        service = MealPlanSetupService.new(user, recipe_params)

        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
          .and change { Recipe.count }.by(0)
                                      .and change { user.meal_plans.count }.by(0)
      end
    end

    context 'when an ingredient fails to save' do
      it 'raises an ActiveRecord::RecordInvalid error and does not create a meal plan or ingredients' do
        allow(Ingredient).to receive(:find_or_create_by!).and_raise(ActiveRecord::RecordInvalid.new(Ingredient.new))

        service = MealPlanSetupService.new(user, recipe_params)

        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
          .and change { Ingredient.count }.by(0)
                                          .and change { user.meal_plans.count }.by(0)
      end
    end

    context 'when the meal plan fails to save' do
      it 'raises an ActiveRecord::RecordInvalid error and does not create a meal plan' do
        service = MealPlanSetupService.new(user, recipe_params)

        allow(user).to receive_message_chain(:meal_plans, :create!).and_raise(ActiveRecord::RecordInvalid.new(MealPlan.new))
        allow(user.meal_plans).to receive(:count).and_return(0)

        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
          .and change { user.meal_plans.count }.by(0)
      end
    end
  end
end
