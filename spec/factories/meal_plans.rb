FactoryBot.define do
  factory :meal_plan do
    user
    recipe
    date { Date.tomorrow }
    sequence(:meal_type) { |n| %w[breakfast lunch dinner snack][n % 4] }
  end
end