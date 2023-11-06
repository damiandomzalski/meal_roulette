require 'httparty'

class MealApiService
  include HTTParty
  base_uri MEAL_API_CONFIG['base_uri']

  def random_recipe
    response = self.class.get(MEAL_API_CONFIG['random_endpoint'])
    if response.success?
      parse_response(response.body)
    else
      log_error(I18n.t('recipes.random.error'), response.body)
      nil
    end
  rescue HTTParty::Error, StandardError => e
    log_error(e.class.name, e.message)
    nil
  end

  def extract_ingredients(recipe)
    (1..20).each_with_object([]) do |i, ingredients|
      ingredient = recipe["strIngredient#{i}"]
      measure = recipe["strMeasure#{i}"]
      ingredients.push({ name: ingredient, quantity: measure }) if ingredient.present? && measure.present?
    end
  end

  private

  def parse_response(body)
    JSON.parse(body)['meals'].first
  rescue JSON::ParserError => e
    log_error('JSON::ParserError', e.message)
    nil
  end

  def log_error(error_type, message)
    Rails.logger.error "#{error_type}: #{message}"
  end
end
