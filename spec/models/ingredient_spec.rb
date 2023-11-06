require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe 'validations' do
    subject { create(:ingredient) }
    let(:ingredient) { build(:ingredient) }

    it 'is valid with valid attributes' do
      expect(ingredient).to be_valid
    end

    it 'is not valid without a name' do
      ingredient.name = nil
      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:name]).to include("can't be blank")
    end

    it 'is not valid with a duplicate name' do
      create(:ingredient, name: 'Sugar')
      ingredient.name = 'Sugar'
      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:name]).to include("has already been taken")
    end

    it 'validates uniqueness of name regardless of case' do
      create(:ingredient, name: 'Sugar')
      ingredient.name = 'sugar'
      expect(ingredient).not_to be_valid
      expect(ingredient.errors[:name]).to include("has already been taken")
    end
  end

  describe 'associations' do
    it { should have_many(:recipe_ingredients).dependent(:destroy) }
    it { should have_many(:recipes).through(:recipe_ingredients) }
  end
end
