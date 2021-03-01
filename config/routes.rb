Rails.application.routes.draw do
  root to: 'stock_checks#new'

  resources :sessions, only: [:new, :create]
  delete '/sessions', to: 'sessions#destroy', as: 'session'

  resources :stock_checks, only: [:new, :show], param: :stock_symbol
  resources :users, only: [:new, :create]
end
