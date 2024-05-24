Rails.application.routes.draw do
  # RESTful routes for Instances
  resources :instances

  # RESTful routes for FeatureModels
  resources :feature_models

  get 'instances/start/:id', to: 'instances#start'
  # If you're using Decidim, mount it properly if it's uncommented
  # mount Decidim::Core::Engine => '/'
end
