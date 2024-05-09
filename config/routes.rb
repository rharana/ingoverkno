Rails.application.routes.draw do
  get 'instance/new'
  get 'instance/create'
  get 'instance/update'
  get 'instance/delete'
  get 'instance/read'
  get 'instance/list'
  # mount Decidim::Core::Engine => '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
