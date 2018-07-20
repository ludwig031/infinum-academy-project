Rails.application.routes.draw do
  scope :api do
    resources :users
    resources :companies
    resources :flights
    resources :bookings
  end

  ActiveAdmin.routes(self)
  get '/world-cup', to: 'application#matches'
end
