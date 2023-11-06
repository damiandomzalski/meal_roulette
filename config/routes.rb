Rails.application.routes.draw do
  devise_for :users

  root 'dashboard#index'

  resources :recipes, only: [:index, :create, :show, :destroy] do
    collection do
      get 'random'
      post 'add_to_meal_plan'
      post 'reject'
    end
  end
end
