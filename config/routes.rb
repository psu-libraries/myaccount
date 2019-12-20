# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  resources :summaries, :fines, :checkouts, :holds
  resources :renewals, only: :create

  get '/logout', to: 'sessions#destroy', as: :logout
end
