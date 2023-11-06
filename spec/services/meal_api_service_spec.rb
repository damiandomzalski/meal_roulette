require 'rails_helper'

RSpec.describe MealApiService, type: :service do
  describe '#random_recipe' do
    let(:dummy_response) do
      {
        "meals" => [
          {
            "strIngredient1" => "Chicken",
            "strMeasure1" => "2 pieces"
          }
        ]
      }.to_json
    end

    before do
      stub_request(:get, "#{MEAL_API_CONFIG['base_uri']}#{MEAL_API_CONFIG['random_endpoint']}")
        .to_return(status: 200, body: dummy_response)
    end

    it 'returns a random recipe when the API call is successful' do
      service = MealApiService.new
      response = service.random_recipe
      expect(response).to be_a(Hash)
      expect(response).to eq(JSON.parse(dummy_response)['meals'].first)
    end

    it 'returns nil and logs an error when the API call fails' do
      stub_request(:get, "#{MEAL_API_CONFIG['base_uri']}#{MEAL_API_CONFIG['random_endpoint']}")
        .to_return(status: 500, body: nil)

      expect(Rails.logger).to receive(:error).with(/error/i)
      service = MealApiService.new
      expect(service.random_recipe).to be_nil
    end

    it 'handles HTTParty errors' do
      stub_request(:get, "#{MEAL_API_CONFIG['base_uri']}#{MEAL_API_CONFIG['random_endpoint']}")
        .to_raise(HTTParty::Error)

      expect(Rails.logger).to receive(:error).with(/HTTParty::Error/i)
      service = MealApiService.new
      expect(service.random_recipe).to be_nil
    end

    it 'handles standard errors' do
      stub_request(:get, "#{MEAL_API_CONFIG['base_uri']}#{MEAL_API_CONFIG['random_endpoint']}")
        .to_raise(StandardError)

      expect(Rails.logger).to receive(:error).with(/StandardError/i)
      service = MealApiService.new
      expect(service.random_recipe).to be_nil
    end
  end
end
