Rails.application.routes.draw do
  root to: 'bookings#index'

  resources :listings, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  end

  resources :bookings, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  end

  resources :reservations, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  end

end
