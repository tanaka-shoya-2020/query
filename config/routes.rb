Rails.application.routes.draw do
  root to: "rooms#index"
  resources :rooms, only: [:index] do
    resources :articles, only: [:index]
  end
end
