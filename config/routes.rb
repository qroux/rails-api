Rails.application.routes.draw do
  root to: 'bookings#index'

  resources :bookings, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
  end
end
