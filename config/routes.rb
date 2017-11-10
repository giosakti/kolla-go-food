Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'home/hello'
  resources :categories
  resources :carts
  root 'store#index', as: 'store_index'
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  resources :carts
  resources :foods
  resources :line_items
  resources :orders
  resources :tags
  resources :users
  resources :vouchers
end
