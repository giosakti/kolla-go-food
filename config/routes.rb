Rails.application.routes.draw do
  resources :categories
  resources :carts
  root 'store#index', as: 'store_index'
  resources :foods
  resources :line_items
  get 'home/hello'
end
