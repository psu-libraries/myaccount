# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'sessions#index'

  require 'sidekiq/web'
  Sidekiq::Web.set :sessions, false
  mount Sidekiq::Web => '/sidekiq'

  resources :summaries, :fines, :checkouts, only: [:index]
  resources :renewals, only: [:create]
  resources :holds, only: [:index, :new, :create]
  resources :redis_jobs, only: [:show, :destroy]
  patch '/holds/batch', to: 'holds#batch_update', as: :holds_batch_update
  delete '/holds/batch', to: 'holds#batch_destroy', as: :holds_batch_destroy

  get 'holds/result', to: 'holds#result', as: :result
  get '/logout', to: 'sessions#destroy', as: :logout

  # error pages
  match '404', to: 'errors#not_found', via: :all
  match '422', to: 'errors#not_found', via: :all
  match '500', to: 'errors#internal_server_error', via: :all

  # catchall for not predefined requests - keep this at the very bottom of the routes file
  match '*catch_unknown_routes', to: 'errors#not_found', via: :all
end
