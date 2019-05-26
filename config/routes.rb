Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #visitor paths
  root to: 'welcome#index'

  resources :items, only: [:index, :show]
  resources :merchants, only: [:index]
  resources :users, only: [:index, :create] #what needs a user index path?
  get '/register', to: "users#new", as: :new_user

  get '/login', to: "sessions#new", as: :login
  post '/login', to: "sessions#create"
  get 'logout', to: "sessions#destroy", as: :logout


  # user_paths
  namespace :profile, module: :user, as: :user do
    get '/', to: "users#show"
    patch '/', to: "users#update"
    get '/edit', to: "users#edit"
    get '/orders', to: "users#orders"
    post '/orders', to: "users#checkout"
  end


  # merchant_paths
  get '/dashboard', to: "merchants#show", as: :merchant_dashboard
  get '/dashboard/orders/:id', to: "order#show", as: :merchant_orders

  # admin_paths
  namespace :admin do
    get '/dashboard', to: 'admin#show'
  end

  resources :carts, only: [:create]
  get '/cart', to: 'carts#show'
  delete '/cart', to: 'carts#destroy'
  delete '/cart/item/:id', to: 'carts#delete_item', as: :cart_delete_item
  post '/cart/item/:id', to: 'carts#add_item', as: :cart_add_item
  patch '/cart/item/:id', to: 'carts#eliminate_item', as: :cart_eliminate_item

end
