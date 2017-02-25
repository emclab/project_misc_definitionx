Rails.application.routes.draw do

  mount ProjectMiscDefinitionx::Engine => "/project_misc_definitionx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  #mount InfoServiceProjectx::Engine => '/project'
  mount Kustomerx::Engine => '/customer'
  mount Searchx::Engine => '/search'
  
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
