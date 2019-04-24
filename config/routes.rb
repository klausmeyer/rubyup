require 'sidekiq/web'

Rails.application.routes.draw do
  root to: redirect('/repositories')

  resources :repositories, only: [:index, :show]
  resources :jobs, only: [:index, :show]

  mount Sidekiq::Web => '/sidekiq'
end
