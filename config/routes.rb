Rails.application.routes.draw do
  # RESTful routes for Instances
  resources :instances do
    member do
      post 'start'
      get 'status'
    end
  end

  # RESTful routes for FeatureModels
  resources :feature_models

  # If you're using Decidim, mount it properly if it's uncommented
  # mount Decidim::Core::Engine => '/'
end
