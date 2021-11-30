Rails.application.routes.draw do
  devise_for :users
    resources :notes do
    resources :comments, only:[:create, :destroy]
    resource :bookmarks, only:[:create, :destroy]
    resource :reminds, only:[:create, :update, :destroy]
  end
  resources :users, only:[:show, :edit, :update]
  get 'search' => 'seaches#index', as:'search'

end
