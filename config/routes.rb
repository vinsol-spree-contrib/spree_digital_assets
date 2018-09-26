Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :digital_assets
    resources :folders, only: [:create, :update, :destroy]
    resources :banners, except: [:show] do
      member do
        patch :activate
        patch :deactivate
      end
      resources :images
    end
  end

end
