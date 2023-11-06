require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { build(:user) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'is not valid with a short password' do
      user.password = 'pass'
      user.password_confirmation = 'pass'
      expect(user).not_to be_valid
    end

    it 'is not valid with a confirmation mismatch' do
      user.password_confirmation = 'mismatch'
      expect(user).not_to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:meal_plans).dependent(:destroy) }
    it { is_expected.to have_many(:recipes).through(:meal_plans) }
  end

  describe 'dependencies' do
    let(:user) { create(:user) }
    let!(:meal_plan) { create(:meal_plan, user: user) }

    it 'destroys meal plans when user is destroyed' do
      expect { user.destroy }.to change(MealPlan, :count).by(-1)
    end
  end
end
