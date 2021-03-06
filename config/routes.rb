Rails.application.routes.draw do
  get 'recommends/' => 'recommends#index', as: 'recommends'
  get 'contacts/new'
  post 'contacts/confirm' => 'contacts/confirm'
  post 'contacts/complete' => 'contacts/complete'
  root to: 'homes#top'
  get 'homes/top'
  get 'homes/about'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: %i(index show edit update)
  resources :notes do
    resources :comments, only: %i(create destroy)
    resource :bookmarks, only: %i(create destroy)
    resource :reminds, only: %i(create update destroy)
  end
  resources :users, only: %i(show edit update)
  get 'search' => 'searches#index', as: 'search'

end
