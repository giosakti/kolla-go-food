Rails.application.routes.draw do
  get 'home/hello'
  root 'store#index', as: 'store_index'
  
  resources :carts
  resources :foods
  resources :line_items
  resources :orders
  resources :users
end
