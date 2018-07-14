# frozen_string_literal: true

Rails.application.routes.draw do
  get '/world-cup', to: 'application#matches'
end
