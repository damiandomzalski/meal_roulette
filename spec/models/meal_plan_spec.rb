require 'rails_helper'

RSpec.describe MealPlan, type: :model do
  let(:user) { create(:user) }
  let(:meal_plan) { build(:meal_plan, user: user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(meal_plan).to be_valid
    end

    it 'is not valid without a date' do
      meal_plan.date = nil
      expect(meal_plan).not_to be_valid
    end

    it 'is not valid without a meal_type' do
      meal_plan.meal_type = nil
      expect(meal_plan).not_to be_valid
    end

    it 'is not valid with an invalid meal_type' do
      meal_plan.meal_type = 'midnight_snack'
      expect(meal_plan).not_to be_valid
    end

    it 'does not allow duplicate meal_type for the same user and date' do
      meal_plan.save
      duplicate_meal_plan = meal_plan.dup
      expect(duplicate_meal_plan).not_to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:recipe) }
  end

  describe 'scopes' do
    describe '.upcoming' do
      it 'includes meal plans from today and in the future' do
        upcoming_meal_plan = create(:meal_plan, date: Date.today, user: user)
        past_meal_plan = create(:meal_plan, date: Date.yesterday, user: user)
        expect(MealPlan.upcoming).to include(upcoming_meal_plan)
        expect(MealPlan.upcoming).not_to include(past_meal_plan)
      end
    end

    describe '.missing_meal_types' do
      it 'returns the meal types not yet planned for a given date' do
        create(:meal_plan, meal_type: 'breakfast', date: Date.tomorrow, user: user)
        expect(MealPlan.missing_meal_types(user, Date.tomorrow)).not_to include('breakfast')
      end
    end
  end

  describe 'uniqueness' do
    it 'does not allow the same meal type for the same user on the same date' do
      create(:meal_plan, meal_type: 'lunch', date: Date.tomorrow, user: user)
      duplicate_meal_plan = build(:meal_plan, meal_type: 'lunch', date: Date.tomorrow, user: user)
      expect(duplicate_meal_plan).not_to be_valid
    end
  end
end
