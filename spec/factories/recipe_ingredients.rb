FactoryBot.define do
  factory :recipe_ingredient do
    recipe
    ingredient
    quantity { "#{rand(1..10)} #{['cups', 'tablespoons', 'teaspoons'].sample}" }
  end
end
