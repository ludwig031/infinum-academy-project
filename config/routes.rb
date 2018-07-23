Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get '/world-cup', to: 'application#matches'
end
