Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :products, only: :show
    resources :users do
      resources :orders, only: %i(index show) do
        resources :order_details, only: :index
      end
    end
  end
end
