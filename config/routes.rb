require 'sidekiq/web'

Rails.application.routes.draw do
  root to: redirect('/repositories')

  resources :repositories, only: [:index, :show, :new, :create, :destroy]
  resources :jobs, only: [:index, :show, :new, :create]

  mount Sidekiq::Web => '/sidekiq'
end
