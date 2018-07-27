Rails.application.routes.draw do

  get 'users/new'
  resources :wikis do
    collection do
      get '/user_wikis', to: 'wikis#user_wikis', as: :user
    end
  end

  get 'charges_controllers/create'
  get 'charges_controllers/new'

  get '/cancel_plan' => 'users#cancel_plan'

  resources :users, only: [:new, :create]
  resources :charges_controllers, only: [:new, :create]

  get 'home/index'
  devise_for :users
  devise_for :models
  root to: "home#index"
  root to: 'wikis#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
