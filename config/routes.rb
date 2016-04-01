Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :digital_assets
    resources :folders, only: [:create, :update, :destroy]
  end

end
