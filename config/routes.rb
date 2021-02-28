Rails.application.routes.draw do
  root to: redirect("/sessions/new")

  resources :sessions, only: [:new, :create, :destroy]
end
