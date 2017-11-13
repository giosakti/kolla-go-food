Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'dashboard' => 'dashboard#index'
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
  resources :foods do
    resources :reviews, only: [:index, :new, :create]
  end
  resources :line_items
  resources :orders
  resources :restaurants do
    resources :reviews, only: [:index, :new, :create]
  end
  resources :tags
  resources :users
  resources :vouchers
end
