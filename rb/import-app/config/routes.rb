Rails.application.routes.draw do
  root to: 'home#index'

  resources :operations, only: [:index] do
    collection do
      get :import
      post :import, to: 'operations#process_import'
    end
  end

  resources :companies, only: [:index]

  resources :import_history, only: [:show]
end
