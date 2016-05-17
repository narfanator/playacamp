Rails.application.routes.draw do
  resources :tickets

  resources :camp_scores

  get 'password_resets/new'

  get 'login', to: 'sessions#new', as: 'login_form'
  post 'login', to: 'sessions#create', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions
  resources :users
  get 'send/:id', to: 'users#send_tickets', as: 'send_user'
  get 'give/:id', to: 'users#give_tickets', as: 'give_user'

  post 'tickets/bulk_update', to: 'tickets#bulk_update', as: 'bulk_update_tickets'

  resources :password_resets

  root to: 'visitors#index'
end
