Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :digital_assets
    resources :folders, only: [:create, :update, :destroy]
    resources :banners, except: [:show] do
      patch :toggle_banner_active_status, on: :member
      resources :images
    end
  end

end
