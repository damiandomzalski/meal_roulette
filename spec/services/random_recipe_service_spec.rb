require 'rails_helper'

RSpec.describe RandomRecipeService do
  let(:user) { create(:user) }
  let(:meal_api_service) { instance_double(MealApiService) }
  let(:random_recipe_service) { described_class.new(user) }

  before do
    allow(MealApiService).to receive(:new).and_return(meal_api_service)
  end

  describe '#call' do
    context 'when there are missing meal types for tomorrow' do
      before do
        allow(MealPlan).to receive(:missing_meal_types).and_return(['breakfast', 'lunch'])
      end

      it 'returns true when a recipe is found' do
        allow(meal_api_service).to receive(:random_recipe).and_return({ 'idMeal' => '12345' })
        allow(meal_api_service).to receive(:extract_ingredients).and_return([{ 'name' => 'Chicken', 'quantity' => '2 pieces' }])

        expect(random_recipe_service.call).to be(true)
        expect(random_recipe_service.recipe).to eq({ 'idMeal' => '12345' })
        expect(random_recipe_service.ingredients).to eq([{ 'name' => 'Chicken', 'quantity' => '2 pieces' }])
      end

      it 'returns false when a recipe is not found' do
        allow(meal_api_service).to receive(:random_recipe).and_return(nil)

        expect(random_recipe_service.call).to be(false)
      end
    end

    context 'when there are no missing meal types for tomorrow' do
      before do
        allow(MealPlan).to receive(:missing_meal_types).and_return([])
      end

      it 'returns false' do
        expect(random_recipe_service.call).to be(false)
      end
    end
  end
end
