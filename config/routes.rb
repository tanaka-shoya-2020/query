Rails.application.routes.draw do
  devise_for :users
  root to: "rooms#index"
  resources :rooms, only: [:index] do
    resources :articles, only: [:index]
  end
end
