Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/login", to: "sessions#new"
    get "/search", to: "searchs#index"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/clear-cart", to: "carts#clear_cart", as: :clear_cart
    post "/orders/new", to: "orders#voucher"
    delete "/orders/new", to: "orders#cancel_voucher"
    resources :products, only: :show do
      resources :ratings, only: %i(index create)
    end
    resources :categories, only: :show
    resources :users do
      resources :orders, only: %i(index show update) do
        resources :order_details, only: :index
      end
    end
    resources :carts, except: %i(show edit new)
    namespace :admin do
      root "base#home"
      resources :orders, only: %i(index update)
    end
    resources :orders, only: %i(new create)
  end
end
