# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  resources :summaries, :fines, :checkouts

  get '/logout', to: 'sessions#destroy', as: :logout
end
