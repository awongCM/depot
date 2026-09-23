Rails.application.routes.draw do
  get "admin" => "admin#index"

  controller :sessions do
    get "login" => :new
    post "login" => :create
    delete "logout" => :destroy
  end

  resources :users
  resources :orders
  resources :line_items do
    post "decrement", on: :member
  end
  resources :carts
  resources :products do
    get "who_bought", on: :member
  end

  root to: "store#index"

  scope "(:locale)" do
    resources :orders
    resources :line_items
    resources :carts
    get "/", to: "store#index", as: "store"
    post "/", to: "store#index"
  end
end
