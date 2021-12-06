Rails.application.routes.draw do
  root to: "notes#index"
  devise_for :users
  resources :users, only:[:show, :edit, :update]
  resources :notes do
    resources :comments, only:[:create, :destroy]
    resource :bookmarks, only:[:create, :destroy]
    resource :reminds, only:[:create, :update, :destroy]
  end
  resources :users, only:[:show, :edit, :update]
  get 'search' => 'searches#index', as:'search'

end
