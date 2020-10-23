Rails.application.routes.draw do
  get 'sessions/new'
  devise_for :users
  root to: "rooms#index"
  resources :rooms, only: [:index, :new, :create] do
    resources :articles, only: [:index]
  end
  resources :sessions, only: [:new, :create, :destroy]
end
