Rails.application.routes.draw do
  get '/world-cup', to: 'application#matches'
end
