require 'rails_helper'

RSpec.describe ShoppingListService do
  describe '#call' do
    let(:ingredient1) { create(:ingredient, name: 'Chicken') }
    let(:ingredient2) { create(:ingredient, name: 'Salt') }
    let(:recipe) { create(:recipe) }

    let!(:recipe_ingredient1) do
      create(:recipe_ingredient, recipe:, ingredient: ingredient1, quantity: '2 pieces')
    end
    let!(:recipe_ingredient2) do
      create(:recipe_ingredient, recipe:, ingredient: ingredient2, quantity: '1 tbsp')
    end

    let(:meal_plan) { create(:meal_plan, recipe:) }

    subject(:service) { described_class.new([meal_plan]) }

    it 'aggregates ingredients and quantities from meal plans' do
      result = service.call

      expect(result).to eq({
                             'Chicken' => '2 pieces',
                             'Salt' => '1 tbsp'
                           })
    end

    context 'when there are no ingredients' do
      let(:meal_plan_without_ingredients) { create(:meal_plan) }

      subject(:service) { described_class.new([meal_plan_without_ingredients]) }

      it 'returns an empty hash' do
        result = service.call

        expect(result).to eq({})
      end
    end
  end
end
