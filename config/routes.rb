Rails.application.routes.draw do
  namespace :api do
    resources :users , except: [:new, :edit]
    resources :companies, except: [:new, :edit]
    resources :flights, except: [:new, :edit]
    resources :bookings, except: [:new, :edit]
    resource :session, only: [:create, :destroy]

    get 'statistics/companies', to: 'companies_statistics#index'
    get 'statistics/flights', to: 'flights_statistics#index'
  end

  ActiveAdmin.routes(self)

  get '/world-cup', to: 'application#matches'
end
