FactoryBot.define do
  factory :recipe do
    sequence(:name) { |n| "Recipe #{n}" }
    instruction { Faker::Food.description }
    category { Faker::Food.ethnic_category }
    area { Faker::Address.country }
    image_url { Faker::Internet.url }
  end
end
