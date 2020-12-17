Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/login", to: "sessions#new"
    get "/search", to: "searchs#index"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/clear-cart", to: "carts#clear_cart", as: :clear_cart
    resources :products, only: :show
    resources :categories, only: :show
    resources :users do
      resources :orders, only: %i(index show update) do
        resources :order_details, only: :index
      end
    end
    resources :carts, except: %i(show edit new)
  end
end
