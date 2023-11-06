require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe 'validations' do
    let(:recipe) { build(:recipe) }

    it 'is valid with valid attributes' do
      expect(recipe).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:recipe_ingredients) }
    it { should have_many(:ingredients).through(:recipe_ingredients) }
  end
end
