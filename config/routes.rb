Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :digital_assets
    resources :folders
  end

end
