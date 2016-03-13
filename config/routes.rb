Spree::Core::Engine.routes.draw do

  namespace :admin do
    resources :digital_assets do
      post :create_multiple, on: :collection
    end
  end

end
