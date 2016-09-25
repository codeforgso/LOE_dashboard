Rails.application.routes.draw do
  resources :cases, only: [:index] do
    get 'autocomplete', on: :collection
  end
  get 'cases/:case_number', controller: :cases, action: :show, as: :case
  resources :case_histories, only: [:show, :index]
  resources :inspections, only: [:show, :index]
  resources :violations, only: [:show, :index]
  resources :pages, only: [:index]
  get 'application/js_config', controller: :application, action: :js_config

  root 'cases#index'
end
