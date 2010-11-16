Archive::Application.routes.draw do
  resources :places
  resources :task_bodiesd
  resources :tasks
  resources :books
  resources :nomenclatures
  resources :direqcias
  resources :users

  match '/login', :controller => :site, :action => :login, :as => :login
  match '/change_password', :controller => :site, :action => :change_password
  match '/logout', :controller => :site, :action => :logout
  match '/search', :controller => :search, :action => :index
  match '/move', :controller => :move, :action => :index
  match '/moveplace', :controller => :move, :action => :move
  match '/change_nomenclature', :controller => :places, :action => :change_nomenclature
  match '/reorder', :controller => :places, :action => :reorder
  match '/print_shelf', :controller => :places, :action => :print_shelf
  match '/reports', :controller => :reports, :action => :index
  match '/newtaskbody/:id', :controller => :tasks, :action => :new_body

  match '/rep_by_direqcia', :controller => :reports, :action => :by_direqcia
  match '/rep_by_direqcia_and_year', :controller => :reports, :action => :by_direqcia_and_year
  match '/rep_by_direqcia_and_enter_year', :controller => :reports, :action => :by_direqcia_and_enter_year
  match '/search_move', :controller => :search, :action => :search_move, :as => :search_move

  # root path
  root :to => 'site#index', :as => :home
end
