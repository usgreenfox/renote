Rails.application.routes.draw do
  resources :notes do
    resources :comments, only:[:create, :destroy]
    resource :bookmarks, only:[:create, :destroy]
    resource :reminds, only:[:create, :update, :destroy]
  end
  resources :users, only:[:show, :edit, :update]
  get 'search' => 'seeaches#index', as:'search'

end