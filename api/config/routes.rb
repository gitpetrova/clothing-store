Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"

      get "profile", to: "profiles#show"
      patch "profile", to: "profiles#update"

      resources :categories, only: %i[index show]
      resources :products, only: %i[index show] do
        resources :variants, only: %i[index show], shallow: true
      end
      resources :orders, only: %i[index show create]

      namespace :admin do
        resources :categories
        resources :products do
          resources :variants, shallow: true
          resources :product_images, shallow: true
        end
        resources :orders, only: %i[index show update]
        resources :users, only: %i[index show update]
      end

      resources :items
    end
  end
end
