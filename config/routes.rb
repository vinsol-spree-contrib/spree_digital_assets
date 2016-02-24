Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :folders
    resources :digital_assets
  end

end

