Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/login", to: "sessions#new"
    get "/search", to: "searchs#index"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :products, only: :show
    resources :categories, only: :show
    resources :users do
      resources :orders, only: %i(index show update) do
        resources :order_details, only: :index
      end
    end
    resources :carts, only: %i(index create)
  end
end
