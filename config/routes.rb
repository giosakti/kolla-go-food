Rails.application.routes.draw do
  resources :carts
  root 'store#index', as: 'store_index'
  resources :foods
  get 'home/hello'
end
