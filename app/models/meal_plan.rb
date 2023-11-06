class MealPlan < ApplicationRecord
  MEAL_TYPES = %w[breakfast lunch dinner snack].freeze

  belongs_to :user
  belongs_to :recipe

  validates :date, presence: true
  validates :meal_type, presence: true, inclusion: { in: MEAL_TYPES }
  validates_uniqueness_of :meal_type, scope: [:user_id, :date]

  scope :upcoming, -> { where("date >= ?", Date.today) }
  scope :missing_meal_types, lambda { |user, date|
    where(user: user, date: date).pluck(:meal_type).then { |types| MEAL_TYPES - types }
  }
end
