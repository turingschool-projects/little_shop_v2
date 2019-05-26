Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # PUBLIC PAGE ROUTES
  root to: "welcome#index"
  resources :items, only: [:index, :show]
  get '/merchants', to: "merchants#index"

  # NEW USER REGISTRATION ROUTES
  get '/register', to: "users#new"
  resources :users, only: [:create]

  # LOGIN/LOGOUT ROUTES
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  get '/logout', to: "sessions#destroy"

  # CART ROUTES
  post '/carts', to: "carts#create"

  scope :cart, as: :cart do
    get '/', to: "carts#show"
    delete '/', to: "carts#destroy"
    post '/', to: 'carts#checkout'
    post '/:id', to: 'carts#add_from_show_page',  as: :add_item
    patch '/:id/increment', to: 'carts#increment', as: :increment_item
    patch '/:id/decrement', to: 'carts#decrement', as: :decrement_item
    patch '/:id/remove', to: 'carts#remove_item', as: :remove_item
  end

  # PROFILE ROUTES (AS A USER)
  scope :profile, module: :user, as: :profile do
    get '/', to: "users#show"
    patch '/', to: "users#update"
    get '/edit', to: "users#edit"
  end

  scope :profile, module: :user, as: :user do
    resources :orders, only: [:index, :show]
    patch '/orders/:id/cancel', to: 'orders#cancel', as: :cancel_order
  end

  # DASHBOARD ROUTES (AS A MERCHANT)
  scope :dashboard, module: :merchant, as: :merchant do
    get '/', to: "merchants#show", as: :dashboard
    resources :items, only: [:index]
  end

  # ADMIN ROUTES
  namespace :admin do
    get '/dashboard', to: "users#show"
    get '/merchants/:id', to: "merchants#show", as: :merchant
    patch '/merchants/:id/disable', to: "merchants#disable", as: :disable_merchant
    patch '/merchants/:id/enable', to: "merchants#enable", as: :enable_merchant
  end
end
