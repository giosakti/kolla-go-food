Rails.application.routes.draw do
  root 'store#index', as: 'store_index'
  resources :foods
  get 'home/hello'
end
