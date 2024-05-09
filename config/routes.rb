Rails.application.routes.draw do

  # get 'instances/update'
  # get 'instances/delete'
  # get 'instances/read'
  # get 'instances/list'
  # get 'instance/:id', to: 'instance#show'
  get "instances/new", to: "instances#new"
  post "instances", to: "instances#create"

  # get 'instance/update'
  # get 'instance/delete'
  # get 'instance/read'
  # get 'instance/list'

  # mount Decidim::Core::Engine => '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
