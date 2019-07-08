Rails.application.routes.draw do
  # root to: 'bookings#index'

  resources :listings, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  end

  resources :bookings, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  end

  resources :reservations, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  end

  resources :missions, only: [:index] do
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :listings, only: [:index, :show, :create, :update, :destroy]
      resources :bookings, only: [:index, :show, :create, :update, :destroy]
      resources :reservations, only: [:index, :show, :create, :update, :destroy]
      resources :missions, only: [:index]
    end
  end
end
