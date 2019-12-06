# frozen_string_literal: true

Rails.application.routes.draw do
  # get 'sessions/index'
  root to: 'sessions#index'

  resources :summaries, :fines

  get '/logout', to: 'sessions#destroy', as: :logout
end
