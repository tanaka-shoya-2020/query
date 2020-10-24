Rails.application.routes.draw do
  get 'sessions/new'
  devise_for :users
  root to: "rooms#index"
  resources :rooms, only: [:index, :new, :create] 
  resources :sessions, only: [:new, :create, :destroy]
  resources :articles do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :users, only: [:show]
end
