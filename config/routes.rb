# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  resources :summaries, :fines, :checkouts, only: [:index]
  resources :renewals, only: [:create]
  resources :holds, only: [:index, :new, :create, :update, :destroy]

  get 'holds/result', to: 'holds#result', as: :result

  get '/logout', to: 'sessions#destroy', as: :logout
end
