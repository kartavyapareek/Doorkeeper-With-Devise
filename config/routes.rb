Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  use_doorkeeper
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # apis
  namespace :api do
    namespace :v1 do
      namespace :auth do
        devise_scope :user do
          post 'sessions', to: 'sessions#create'
          delete 'sessions', to: 'sessions#destroy'
          post 'registrations', to: 'registrations#create'
        end
      end
      get 'user-profile', to: 'user_profile#show'
      post 'user-profile', to: 'user_profile#update'
      resources :product, except: [:new, :edit]
      resources :order, except: [:new, :edit, :destroy]
      get 'user-product', to: 'order#show_user_all_products'
      get 'user-product/:id', to: 'order#show_user_single_product'
    end
  end
end
