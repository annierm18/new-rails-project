Rails.application.routes.draw do

  get 'users/new'
  resources :wikis
  get 'home/index'
  devise_for :users
  devise_for :models
  root to: "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
