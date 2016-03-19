Rails.application.routes.draw do
  resources :camp_scores

  get 'password_resets/new'

  get 'login', to: 'sessions#new', as: 'login_form'
  post 'login', to: 'sessions#create', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions
  resources :users
  resources :password_resets

  root to: 'visitors#index'
end
